//
//  EzSampleObjectCustomProperties.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObjectCustomPropertiesWithSynchronized.h"

@interface EzSampleObjectCustomPropertiesWithSynchronized ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleObjectCustomPropertiesWithSynchronized

- (void)setValueForReplaceByAtomic:(struct EzSampleObjectStructValue)valueForReplaceByAtomic
{
	@synchronized (self)
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
	@synchronized (self)
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
	@synchronized (self)
	{
		return _valueForReplaceByAtomicReadAndNonAtomicWrite;
	}
}

- (BOOL)outputStructState:(struct EzSampleObjectStructValue)value withLabel:(NSString*)label
{
	BOOL threadSafe = (value.a == value.b);
	
	EzPostLog(@"[%@] ** %@ ** : %d, %d", label, (threadSafe ? @"SAFE" : @"UNSAFE"), value.a, value.b);
	
	return threadSafe;
}

- (void)outputLoopCount
{
	EzPostReport(@"Count of executed by non-atomic = %d (thread-safe=%@)", self.loopCountOfValueForReplaceByNonAtomic, (self.inconsistentReplaceByNonAtomic ? @"NO" : @"YES"));
	EzPostReport(@"Count of executed by atomic = %d (thread-safe=%@)", self.loopCountOfValueForReplaceByAtomic, (self.inconsistentReplaceByAtomic ? @"NO" : @"YES"));
	EzPostReport(@"Count of executed by atomic read and non-atomic write = %d (thread-safe=%@)", self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite, (self.inconsistentReplaceByAtomicReadAndNonAtomicWrite ? @"NO" : @"YES"));
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

- (void)outputWithLabel:(NSString *)label
{
	NSString* labelForAtomic = [[NSString alloc] initWithFormat:@"%@-ATOMIC", label];
	NSString* labelForNonAtomic = [[NSString alloc] initWithFormat:@"%@-NONATOMIC", label];
	NSString* labelForAtomicReadAndNonAtomicWrite = [[NSString alloc] initWithFormat:@"%@-(R)ATOMIC-(W)NONATOMIC", label];
	
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
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end
