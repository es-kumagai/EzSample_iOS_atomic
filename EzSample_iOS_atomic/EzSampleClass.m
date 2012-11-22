//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClass.h"

#define EzSampleClassLoggingCount 10

@interface EzSampleClass ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleClass

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_valueForReplaceByAtomic = [[EzSampleObjectClassValue alloc] initWithLabel:@"ATOMIC"];
		_valueForReplaceByNonAtomic = [[EzSampleObjectClassValue alloc] initWithLabel:@"NONATOMIC"];
		_valueForReplaceByAtomicReadAndNonAtomicWrite = [[EzSampleObjectClassValue alloc] initWithLabel:@"(R)ATOMIC-(W)NONATOMIC"];
	}
	
	return self;
}

- (BOOL)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label
{
	BOOL threadSafe = (value->a == value->b);
	
	EzPostLog(@"%-15s : %2s (%d,%d)", label.UTF8String, (threadSafe ? "OK" : "NG"), value->a, value->b);
	
	return threadSafe;
}

- (void)outputLoopCount
{
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	formatter.groupingSeparator = @",";
	formatter.groupingSize = 3;
	
	EzPostReport(@"ATOMIC          : %12s times (%@)", [formatter stringFromNumber:[[NSNumber alloc] initWithInt:self.loopCountOfValueForReplaceByAtomic]].UTF8String, (self.inconsistentReplaceByAtomic ? @"UNSAFE" : @"SAFE ?"));
	EzPostReport(@"NONATOMIC       : %12s times (%@)", [formatter stringFromNumber:[[NSNumber alloc] initWithInt:self.loopCountOfValueForReplaceByNonAtomic]].UTF8String, (self.inconsistentReplaceByNonAtomic ? @"UNSAFE" : @"SAFE ?"));
	EzPostReport(@"R:ATOM-W:DIRECT : %12s times (%@)", [formatter stringFromNumber:[[NSNumber alloc] initWithInt:self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite]].UTF8String, (self.inconsistentReplaceByAtomicReadAndNonAtomicWrite ? @"UNSAFE" : @"SAFE ?"));
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
	
	if (![self outputStructState:self.valueForReplaceByAtomic withLabel:labelForAtomic]) self.inconsistentReplaceByAtomic = YES;
	if (![self outputStructState:self.valueForReplaceByNonAtomic withLabel:labelForNonAtomic]) self.inconsistentReplaceByNonAtomic = YES;
	if (![self outputStructState:self.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:labelForAtomicReadAndNonAtomicWrite]) self.inconsistentReplaceByAtomicReadAndNonAtomicWrite = YES;
}

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
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
		
		if (logging) NSLog(@"NONATOMIC: Property will read.");
		EzSampleObjectClassValue* value = self.valueForReplaceByNonAtomic;
		if (logging) NSLog(@"NONATOMIC: Property did read.");
		
		value->a = _loopCountOfValueForReplaceByNonAtomic;
		value->b = _loopCountOfValueForReplaceByNonAtomic;
		
		if (logging) NSLog(@"NONATOMIC: Property will write.");
		self.valueForReplaceByNonAtomic = value;
		if (logging) NSLog(@"NONATOMIC: Property did write.");
		
		if (_loggingCountForReplaceByNonAtomic == EzSampleClassLoggingCount)
		{
			[EzSampleObjectClassValue setLogTargetThread:nil];
		}
	}
	
	_threadForValueForReplaceByNonAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
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
		
		if (logging) NSLog(@"ATOMIC: Property will read.");
		EzSampleObjectClassValue* value = self.valueForReplaceByAtomic;
		if (logging) NSLog(@"ATOMIC: Property did read.");
		
		value->a = _loopCountOfValueForReplaceByAtomic;
		value->b = _loopCountOfValueForReplaceByAtomic;
		
		if (logging) NSLog(@"ATOMIC: Property will write.");
		self.valueForReplaceByAtomic = value;
		if (logging) NSLog(@"ATOMIC: Property did write.");
		
		if (_loggingCountForReplaceByAtomic == EzSampleClassLoggingCount)
		{
			[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByNonAtomic];
		}
	}
	
	_threadForValueForReplaceByAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	while (!currentThread.isCancelled)
	{
		_loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite++;
		
		EzSampleObjectClassValue* value = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
		
		value->a = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
		value->b = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
		
		_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end
