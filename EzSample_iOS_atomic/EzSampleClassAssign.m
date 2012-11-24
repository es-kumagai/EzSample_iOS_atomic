//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassAssign.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define EzSampleClassLoggingCount 10

@interface EzSampleClassAssign ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleClassAssign

- (id)init
{
	self = [super init];
	
	if (self)
	{
	}
	
	return self;
}

- (BOOL)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label
{
	BOOL threadSafe;

	if (value->valid == 0)
	{
		threadSafe = (value->a == value->b);
		EzPostLog(@"%-15s : %2s (%d,%d)", label.UTF8String, (threadSafe ? "OK" : "NG"), value->a, value->b);
	}
	else
	{
		threadSafe = NO;
		EzPostLog(@"%-15s : DEALLOC", label.UTF8String);
	}
	
	return threadSafe;
}

- (void)outputLoopCount
{
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	formatter.groupingSeparator = @",";
	formatter.groupingSize = 3;
	
	if (self.errorMessageForReplaceByAtomic)
	{
		EzPostReport(@"ATOMIC : %@", self.errorMessageForReplaceByAtomic);
	}
	else
	{
		EzPostReport(@"ATOMIC          : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByAtomic]].UTF8String, (self.inconsistentReplaceByAtomic ? @"UNSAFE" : @"SAFE ?"));
	}
	
	if (self.errorMessageForReplaceByNonAtomic)
	{
		EzPostReport(@"NONATOMIC : %@", self.errorMessageForReplaceByNonAtomic);
	}
	else
	{
		EzPostReport(@"NONATOMIC       : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByNonAtomic]].UTF8String, (self.inconsistentReplaceByNonAtomic ? @"UNSAFE" : @"SAFE ?"));
	}
	
	if (self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite)
	{
		EzPostReport(@"R:ATOM-W:DIRECT : %@", self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite);
	}
	else
	{
		EzPostReport(@"R:ATOM-W:DIRECT : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite]].UTF8String, (self.inconsistentReplaceByAtomicReadAndNonAtomicWrite ? @"UNSAFE" : @"SAFE ?"));
	}
	
	[formatter release];
}

- (void)start
{
	_threadForValueForReplaceByNonAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByNonAtomic:) object:nil];
	_threadForValueForReplaceByAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomic:) object:nil];
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:) object:nil];
	
	[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByAtomic];
	
	[_threadForValueForReplaceByNonAtomic start];
	[_threadForValueForReplaceByAtomic start];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite start];
	
	//	self.errorMessageForReplaceByNonAtomic = @"Cannot test because hungup causes EXC_BAD_ACCESS.";
}

- (void)stop
{
	[_threadForValueForReplaceByNonAtomic cancel];
	[_threadForValueForReplaceByAtomic cancel];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite cancel];
}

- (void)outputWithLabel:(NSString *)label
{
	NSString* labelForAtomic = [[NSString alloc] initWithFormat:@"%@ATOMIC", label];
	NSString* labelForNonAtomic = [[NSString alloc] initWithFormat:@"%@NONATOMIC", label];
	NSString* labelForAtomicReadAndNonAtomicWrite = [[NSString alloc] initWithFormat:@"%@R:ATOM-W:DIRECT", label];
	
	EzPostLog(@"");
	
	if (_threadForValueForReplaceByAtomic.isExecuting)
	{
		if (![self outputStructState:self.valueForReplaceByAtomic withLabel:labelForAtomic]) self.inconsistentReplaceByAtomic = YES;
	}
	else
	{
		EzPostLog(@"%-15s : SKIP", labelForAtomic.UTF8String);
	}
	
	if (_threadForValueForReplaceByNonAtomic.isExecuting)
	{
		if (![self outputStructState:self.valueForReplaceByNonAtomic withLabel:labelForNonAtomic]) self.inconsistentReplaceByNonAtomic = YES;
	}
	else
	{
		EzPostLog(@"%-15s : SKIP", labelForNonAtomic.UTF8String);
	}
	
	if (_threadForValueForReplaceByAtomicReadAndNonAtomicWrite.isExecuting)
	{
		if (![self outputStructState:self.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:labelForAtomicReadAndNonAtomicWrite]) self.inconsistentReplaceByAtomicReadAndNonAtomicWrite = YES;
	}
	else
	{
		EzPostLog(@"%-15s : SKIP", labelForAtomicReadAndNonAtomicWrite.UTF8String);
	}
	
	[labelForAtomic release];
	[labelForNonAtomic release];
	[labelForAtomicReadAndNonAtomicWrite release];
}

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByNonAtomic++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByNonAtomic == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByNonAtomic = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByNonAtomic++;
			}
			
			BOOL logging = (_loggingCountForReplaceByNonAtomic > 0 && _loggingCountForReplaceByNonAtomic <= EzSampleClassLoggingCount);
			
			// Weak ポインタへの操作のため、ここでインスタンスを生成します。
			EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:@"NONATOMIC"];
			
			value->a = _loopCountOfValueForReplaceByNonAtomic;
			value->b = _loopCountOfValueForReplaceByNonAtomic;
			
			if (logging) NSLog(@"NONATOMIC: Property will write.");
			self.valueForReplaceByNonAtomic = value;
			if (logging) NSLog(@"NONATOMIC: Property did write.");
			
			@autoreleasepool
			{
				// ローカルスコープを定義します。
				{
					if (logging) NSLog(@"NONATOMIC: Property will read.");
					EzSampleObjectClassValue* temp = self.valueForReplaceByNonAtomic;
					if (logging) NSLog(@"NONATOMIC: Property did read.");
					if (logging) NSLog(@"%@", temp);
					
					if (logging) NSLog(@"NONATOMIC: Will End of local scope.");
				}
				
				if (logging) NSLog(@"NONATOMIC: Did End of local scope.");
				
				if (logging) NSLog(@"NONATOMIC: Will End of autorelease pool.");
			}
			
			if (logging) NSLog(@"NONATOMIC: End of autorelease pool.");
			
			[value release];
			
			if (_loggingCountForReplaceByNonAtomic == EzSampleClassLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:nil];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByNonAtomic = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByNonAtomic);
	}
	
	_threadForValueForReplaceByNonAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByAtomic++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByAtomic == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByAtomic = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByAtomic++;
			}
			
			BOOL logging = (_loggingCountForReplaceByAtomic > 0 && _loggingCountForReplaceByAtomic <= EzSampleClassLoggingCount);
			
			// Weak ポインタへの操作のため、ここでインスタンスを生成します。
			EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:@"ATOMIC"];
			
			value->a = _loopCountOfValueForReplaceByAtomic;
			value->b = _loopCountOfValueForReplaceByAtomic;
			
			if (logging) NSLog(@"ATOMIC: Property will write.");
			self.valueForReplaceByAtomic = value;
			if (logging) NSLog(@"ATOMIC: Property did write.");
			
			@autoreleasepool
			{
				// ローカルスコープを定義します。
				{
					if (logging) NSLog(@"ATOMIC: Property will read.");
					EzSampleObjectClassValue* temp = self.valueForReplaceByAtomic;
					if (logging) NSLog(@"ATOMIC: Property did read.");
					if (logging) NSLog(@"%@", temp);
					
					if (logging) NSLog(@"ATOMIC: Will End of local scope.");
				}
				
				if (logging) NSLog(@"ATOMIC: Did End of local scope.");
				
				if (logging) NSLog(@"ATOMIC: Will End of autorelease pool.");
			}
			
			if (logging) NSLog(@"ATOMIC: End of autorelease pool.");
			
			[value release];
			
			if (_loggingCountForReplaceByAtomic == EzSampleClassLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByNonAtomic];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomic = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomic);
	}
	
	_threadForValueForReplaceByAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByAtomicReadAndNonAtomicWrite = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByAtomicReadAndNonAtomicWrite++;
			}
			
			BOOL logging = (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite > 0 && _loggingCountForReplaceByAtomicReadAndNonAtomicWrite <= EzSampleClassLoggingCount);
			
			// Weak ポインタへの操作のため、ここでインスタンスを生成します。
			EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:@"(R)ATOMIC-(W)NONATOMIC"];
			
			value->a = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			value->b = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			
			if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Property will write.");
			_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
			if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Property did write.");
			
			@autoreleasepool
			{
				// ローカルスコープを定義します。
				{
					if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Property will read.");
					EzSampleObjectClassValue* temp = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
					if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Property did read.");
					if (logging) NSLog(@"%@", temp);
					
					if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Will End of local scope.");
				}
				
				if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Did End of local scope.");
				
				if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: Will End of autorelease pool.");
			}
			
			if (logging) NSLog(@"(R)ATOMIC-(W)NONATOMIC: End of autorelease pool.");
			
			[value release];
			
			if (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite == EzSampleClassLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:nil];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite);
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end