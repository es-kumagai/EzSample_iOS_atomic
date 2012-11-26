//
//  EzSampleObjectCustomProperties.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObjectCustomPropertiesWithIVarSynchronizedForEachWithSleep.h"

#define EzSampleObjectCustomPropertiesWithSleepInterval 0.0000001

@interface EzSampleObjectCustomPropertiesWithIVarSynchronizedForEachWithSleep ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleObjectCustomPropertiesWithIVarSynchronizedForEachWithSleep

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_lockForAtomic = [[NSObject alloc] init];
		_lockForAtomicReadAndNonAtomicWrite = [[NSObject alloc] init];
	}
	
	return self;
}

- (void)setValueForReplaceByAtomic:(struct EzSampleObjectStructValue)valueForReplaceByAtomic
{
	@synchronized (_lockForAtomic)
	{
		_valueForReplaceByAtomic = valueForReplaceByAtomic;
	}
}

- (void)setValueForReplaceByNonAtomic:(struct EzSampleObjectStructValue)valueForReplaceByNonAtomic
{
	_valueForReplaceByNonAtomic = valueForReplaceByNonAtomic;
}

- (void)setValueForReplaceByAtomicReadAndNonAtomicWrite:(struct EzSampleObjectStructValue)valueForReplaceByAtomicReadAndNonAtomicWrite
{
	_valueForReplaceByAtomicReadAndNonAtomicWrite = valueForReplaceByAtomicReadAndNonAtomicWrite;
}

- (struct EzSampleObjectStructValue)valueForReplaceByAtomic
{
	@synchronized (_lockForAtomic)
	{
		return _valueForReplaceByAtomic;
	}
}

- (struct EzSampleObjectStructValue)valueForReplaceByNonAtomic
{
	return _valueForReplaceByNonAtomic;
}

- (struct EzSampleObjectStructValue)valueForReplaceByAtomicReadAndNonAtomicWrite
{
	@synchronized (_lockForAtomicReadAndNonAtomicWrite)
	{
		return _valueForReplaceByAtomicReadAndNonAtomicWrite;
	}
}

- (BOOL)outputStructState:(struct EzSampleObjectStructValue)value withLabel:(NSString*)label
{
	BOOL threadSafe = (value.a == value.b);
	
	EzPostLog(@"%-15s : %2s (%d,%d)", label.UTF8String, (threadSafe ? "OK" : "NG"), value.a, value.b);
	
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

- (void)output
{
	NSString* labelForAtomic = @"ATOMIC";
	NSString* labelForNonAtomic = @"NONATOMIC";
	NSString* labelForAtomicReadAndNonAtomicWrite = @"R:ATOM-W:DIRECT";
	
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
		
		struct EzSampleObjectStructValue value = self.valueForReplaceByNonAtomic;
		
		value.a = _loopCountOfValueForReplaceByNonAtomic;
		value.b = _loopCountOfValueForReplaceByNonAtomic;
		
		self.valueForReplaceByNonAtomic = value;
		
		[NSThread sleepForTimeInterval:EzSampleObjectCustomPropertiesWithSleepInterval];
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
		
		struct EzSampleObjectStructValue value = self.valueForReplaceByAtomic;
		
		value.a = _loopCountOfValueForReplaceByAtomic;
		value.b = _loopCountOfValueForReplaceByAtomic;
		
		self.valueForReplaceByAtomic = value;
		
		[NSThread sleepForTimeInterval:EzSampleObjectCustomPropertiesWithSleepInterval];
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
		
		struct EzSampleObjectStructValue value = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
		
		value.a = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
		value.b = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
		
		_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
		
		[NSThread sleepForTimeInterval:EzSampleObjectCustomPropertiesWithSleepInterval];
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end
