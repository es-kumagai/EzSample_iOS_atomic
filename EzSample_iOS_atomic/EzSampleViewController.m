//
//  EzSampleViewController.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleViewController.h"
#import "EzSampleMenuViewController.h"

@interface EzSampleViewController () <EzSampleMenuViewControllerDelegate>

- (void)EzCheck:(id<EzSampleObjectProtocol>)object;
- (void)EzCheckDone:(id<EzSampleObjectProtocol>)object;

- (void)EzPostProgressNotification:(NSNotification*)notification;
- (void)EzPostLogNotification:(NSNotification*)notification;
- (void)EzPostReportNotification:(NSNotification*)notification;

@end

@implementation EzSampleViewController
{
	__strong EzSampleMenuViewController* _menuViewContrller;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self clearOutputs];
	
	_menuViewContrller = [self.storyboard instantiateViewControllerWithIdentifier:@"MENU"];
	_menuViewContrller.delegate = self;
	
	self.menuScrollView.contentSize = _menuViewContrller.view.frame.size;
	
	[self addChildViewController:_menuViewContrller];
	[self.menuScrollView addSubview:_menuViewContrller.view];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[_menuViewContrller.view removeFromSuperview];
	[_menuViewContrller removeFromParentViewController];
	
	_menuViewContrller = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostProgressNotification:) name:@"PROGRESS" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostLogNotification:) name:@"LOG" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EzPostReportNotification:) name:@"REPORT" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearOutputs
{
	self.logTextView.text = @"";
	self.reportTextView.text = @"";
	self.progressView.progress = 0.0;
}

- (void)EzPostProgressNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		self.progressView.progress = (float)(((NSNumber*)notification.object).intValue) / (float)EzSampleViewControllerTestStep;
	}
	else
	{
		[self performSelectorOnMainThread:@selector(EzPostProgressNotification:) withObject:notification waitUntilDone:YES];
	}
}

- (void)EzPostLogNotification:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		self.logTextView.text = [[NSString alloc] initWithFormat:@"%@\n%@", notification.object, self.logTextView.text];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(EzPostLogNotification:) withObject:notification waitUntilDone:YES];
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
		[self performSelectorOnMainThread:@selector(EzPostReportNotification:) withObject:notification waitUntilDone:YES];
	}
}

- (void)EzSampleMenuViewController:(EzSampleMenuViewController *)menuViewController testButtonForTestInstancePushed:(id<EzSampleObjectProtocol>)testInstance
{
	[self clearOutputs];
	
	_menuViewContrller.menuButtonsEnabled = [[NSNumber alloc] initWithBool:NO];
	
	EzPostLog(@"Testing thread-safe %d times.", EzSampleViewControllerTestStep);
	EzPostLog(@"Data size: void=%lu, long=%lu, int=%lu, long long=%lu", sizeof(void), sizeof(long), sizeof(int), sizeof(long long));
		
	[testInstance start];
	
	[self performSelectorInBackground:@selector(EzCheck:) withObject:testInstance];
}

- (void)EzCheck:(id<EzSampleObjectProtocol>)testInstance
{
	NSUInteger step = EzSampleViewControllerTestStep;
	
	[NSThread sleepForTimeInterval:2.0];
	
	@try
	{
		while (step--)
		{
			EzPostProgress(EzSampleViewControllerTestStep - step);
			
			[testInstance outputWithLabel:@"CHECK"];
		}
	}
	@catch (NSException* exception)
	{
		EzPostLog(@"The check thread aborted because %@.", exception.reason);
	}
	@finally
	{
		[self EzCheckDone:testInstance];
	}
}

- (void)EzCheckDone:(id<EzSampleObjectProtocol>)testInstance
{
	[testInstance stop];
	
	[NSThread sleepForTimeInterval:1.0];
	
	[testInstance outputLoopCount];

	[_menuViewContrller performSelectorOnMainThread:@selector(setMenuButtonsEnabled:) withObject:[[NSNumber alloc] initWithBool:YES] waitUntilDone:NO];
}

@end
