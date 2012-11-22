//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleLongLong.h"

@interface EzSampleLongLong ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleLongLong

@synthesize valueForReplaceByAtomic = _valueForReplaceByAtomic;

- (BOOL)outputStructState:(long long)value withLabel:(NSString*)label
{
	BOOL threadSafe = (value == 1 || value == -1);
	
	EzPostLog(@"[%@] ** %@ ** : %lld", label, (threadSafe ? @"SAFE" : @"UNSAFE"), value);
	
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
		
		long long value = self.valueForReplaceByNonAtomic;
		
		value = (_loopCountOfValueForReplaceByNonAtomic % 2 == 0 ? 1 : -1);
		
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
		
		long long value = self.valueForReplaceByAtomic;
		
		value = (_loopCountOfValueForReplaceByAtomic % 2 == 0 ? 1 : -1);
		
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
		
		long long value = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
		
		value = (_loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite % 2 == 0 ? 1 : -1);
		
		_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end
