//
//  EzSampleViewController.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleViewController.h"

@interface EzSampleViewController () <EzSampleMenuViewControllerDelegate>

- (void)EzCheck:(id<EzSampleObjectProtocol>)object;
- (void)EzCheckDone:(id<EzSampleObjectProtocol>)object;

- (void)EzPostProgressNotification:(NSNotification*)notification;
- (void)EzPostClearNotification:(NSNotification*)notification;
- (void)EzPostLogNotification:(NSNotification*)notification;
- (void)EzPostReportNotification:(NSNotification*)notification;

- (void)EzUpdateLogThread:(id)object;
- (void)EzUpdateLog:(NSNumber*)boolFull;

@end

@implementation EzSampleViewController
{
	__strong NSMutableArray* _logBuffer;
	__strong NSThread* _updateLogThread;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_logBuffer = [[NSMutableArray alloc] init];
	
	[self clearOutputs];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	_logBuffer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostProgressNotification:) name:@"PROGRESS" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostLogNotification:) name:@"LOG" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostClearNotification:) name:@"CLEAR" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostReportNotification:) name:@"REPORT" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearOutputs
{
	[_logBuffer removeAllObjects];
	
	self.logTextView.text = @"";
	self.reportTextView.text = @"";
	self.progressView.progress = 0.0;
}

- (void)EzPostClearNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		[self clearOutputs];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(clearOutputs) withObject:nil waitUntilDone:NO];
	}
}

- (void)EzPostProgressNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		self.progressView.progress = (float)(((NSNumber*)notification.object).intValue) / (float)EzSampleViewControllerTestStep;
	}
	else
	{
		[self performSelectorOnMainThread:@selector(EzPostProgressNotification:) withObject:notification waitUntilDone:NO];
	}
}

- (void)EzPostLogNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		[_logBuffer addObject:notification.object];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(EzPostLogNotification:) withObject:notification waitUntilDone:NO];
	}
}

- (void)EzPostReportNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		self.reportTextView.text = [[NSString alloc] initWithFormat:@"%@\n%@", self.reportTextView.text, notification.object];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(EzPostReportNotification:) withObject:notification waitUntilDone:NO];
	}
}

- (void)EzUpdateLogThread:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	while (!currentThread.isCancelled)
	{
		[self performSelectorOnMainThread:@selector(EzUpdateLog:) withObject:nil waitUntilDone:YES];
		
		[NSThread sleepForTimeInterval:0.25];
	}
	
	// キャンセル直後にもう一度、新着ログを表示しておきます。
	[self performSelectorOnMainThread:@selector(EzUpdateLog:) withObject:nil waitUntilDone:YES];
	
	_updateLogThread = nil;
	
	[NSThread exit];
}

- (void)EzUpdateLog:(NSNumber *)boolFull
{
	NSString* text;
	
	if (boolFull.boolValue)
	{
		NSArray* logs = [[_logBuffer reverseObjectEnumerator] allObjects];
		
		text = [logs componentsJoinedByString:@"\n"];
	}
	else
	{
		NSUInteger limit = 30;
	
		text = @"";
		
		for (NSString* log in _logBuffer.reverseObjectEnumerator)
		{
			text = [text stringByAppendingFormat:@"%@\n", log];
			
			if (--limit == 0)
			{
				break;
			}
		}
	}
	
	self.logTextView.text = text;
}

- (void)EzSampleMenuTableViewController:(EzSampleMenuTableViewController*)menuTableViewController testButtonForTestInstancePushed:(id<EzSampleObjectProtocol>)testInstance
{
	_menuTableViewController.tableView.userInteractionEnabled = NO;
	self.logTextView.scrollEnabled = NO;

	EzPostLog(@"Testing thread-safe, checking %d times.", EzSampleViewControllerTestStep);
	EzPostLog(@"Data size: void=%lu, long=%lu, int=%lu, long long=%lu", sizeof(void), sizeof(long), sizeof(int), sizeof(long long));
	EzPostMark;
	
	[testInstance start];
	
	[self performSelectorInBackground:@selector(EzCheck:) withObject:testInstance];
}

- (void)EzCheck:(id<EzSampleObjectProtocol>)testInstance
{
	NSUInteger step = EzSampleViewControllerTestStep;
	
	_updateLogThread = [[NSThread alloc] initWithTarget:self selector:@selector(EzUpdateLogThread:) object:nil];
	
	[_updateLogThread start];
	
	[NSThread sleepForTimeInterval:2.5];
	
	@try
	{
		while (step--)
		{
			if (step % 100 == 0)
			{
				EzPostProgress(EzSampleViewControllerTestStep - step);
			}
			
			[testInstance outputWithLabel:@""];
		}
		
		EzPostMark;
		EzPostLog(@"This check has been finished successfully.");
	}
	@catch (NSException* exception)
	{
		EzPostMark;
		EzPostLog(@"The check thread aborted because %@.", exception.reason);
	}

	// 終了処理に時間がかかることを伝えます。
	EzPostLog(@"");
	EzPostLog(@"Please wait, Report making now ...");
	
	// 直前に送信したログが反映される余地を与えます。
	[NSThread sleepForTimeInterval:1.0];
			
	// ログの更新処理を終了します。
	[_updateLogThread cancel];
	
	// チェック完了処理を行います。
	[self performSelectorOnMainThread:@selector(EzCheckDone:) withObject:testInstance waitUntilDone:NO];
}

- (void)EzCheckDone:(id<EzSampleObjectProtocol>)testInstance
{
	[testInstance stop];

	[_logBuffer addObject:@"Done."];
	
	[self EzUpdateLog:[[NSNumber alloc] initWithBool:YES]];
	[testInstance outputLoopCount];

	self.logTextView.scrollEnabled = YES;
	_menuTableViewController.tableView.userInteractionEnabled = YES;
}

@end
