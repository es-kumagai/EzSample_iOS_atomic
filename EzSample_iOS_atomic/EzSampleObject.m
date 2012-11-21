//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObject.h"

@interface EzSampleObject ()

//- (void)EzThreadLoopForValueForDirectlyByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
//- (void)EzThreadLoopForValueForDirectlyByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
//- (void)EzThreadLoopForValueForDirectlyByAtomicReadAndNonAtomicWrite:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

- (void)EzInternalOutputThread:(id)object;

@end

@implementation EzSampleObject

//@synthesize valueForDirectlyByAtomicReadAndNonAtomicWrite = _valueForDirectlyByAtomicReadAndNonAtomicWrite;
@synthesize valueForReplaceByAtomicReadAndNonAtomicWrite = _valueForReplaceByAtomicReadAndNonAtomicWrite;

+ (void)outputStructState:(struct EzSampleObjectStructValue)value withLabel:(NSString*)label
{
	NSLog(@"[%@] ** %@ ** : %d, %d", label, (value.a == value.b ? @"OK" : @"INCONSISTENCY"), value.a, value.b);
}

- (void)start
{
	_threadForInternalOutput = [[NSThread alloc] initWithTarget:self selector:@selector(EzInternalOutputThread:) object:nil];
	
//	_threadForValueForDirectlyByNonAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForDirectlyByNonAtomic:) object:nil];
	_threadForValueForReplaceByNonAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByNonAtomic:) object:nil];
//	_threadForValueForDirectlyByAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForDirectlyByAtomic:) object:nil];
	_threadForValueForReplaceByAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomic:) object:nil];
//	_threadForValueForDirectlyByAtomicReadAndNonAtomicWrite = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForDirectlyByAtomicReadAndNonAtomicWrite:) object:nil];
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:) object:nil];

//	[_threadForValueForDirectlyByNonAtomic start];
	[_threadForValueForReplaceByNonAtomic start];
//	[_threadForValueForDirectlyByAtomic start];
	[_threadForValueForReplaceByAtomic start];
//	[_threadForValueForDirectlyByAtomicReadAndNonAtomicWrite start];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite start];
	
	[_threadForInternalOutput start];
}

- (void)stop
{
//	[_threadForValueForDirectlyByNonAtomic cancel];
	[_threadForValueForReplaceByNonAtomic cancel];
//	[_threadForValueForDirectlyByAtomic cancel];
	[_threadForValueForReplaceByAtomic cancel];
//	[_threadForValueForDirectlyByAtomicReadAndNonAtomicWrite cancel];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite cancel];
	
	[_threadForInternalOutput cancel];
}

- (void)EzInternalOutputThread:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	if (!currentThread.isCancelled)
	{
		[[self class] outputStructState:_valueForReplaceByAtomic withLabel:@"INTERNAL-ATOMIC"];
		[[self class] outputStructState:_valueForReplaceByNonAtomic withLabel:@"INTERNAL-NONATOMIC"];
		[[self class] outputStructState:_valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:@"INTERNAL-(R)ATOMIC-(W)NONATOMIC"];
	}
	
	[NSThread exit];
}

//- (void)EzThreadLoopForValueForDirectlyByNonAtomic:(id)object
//{
//	NSThread* currentThread = [NSThread currentThread];
//	
//	while (!currentThread.isCancelled)
//	{
//		_loopCountOfValueForDirectlyByNonAtomic++;
//		
//		self.valueForDirectlyByNonAtomic.a = _loopCountOfValueForDirectlyByNonAtomic;
//		self.valueForDirectlyByNonAtomic.b = _loopCountOfValueForDirectlyByNonAtomic;
//	}
//		
//	_threadForValueForDirectlyByNonAtomic = nil;
//	
//	[NSThread exit];
//}

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

//- (void)EzThreadLoopForValueForDirectlyByAtomic:(id)object
//{
//	NSThread* currentThread = [NSThread currentThread];
//	
//	while (!currentThread.isCancelled)
//	{
//		_loopCountOfValueForDirectlyByAtomic++;
//		
//		self.valueForDirectlyByAtomic.a = _loopCountOfValueForDirectlyByAtomic;
//		self.valueForDirectlyByAtomic.b = _loopCountOfValueForDirectlyByAtomic;
//	}
//	
//	_threadForValueForDirectlyByAtomic = nil;
//	
//	[NSThread exit];
//}

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

//- (void)EzThreadLoopForValueForDirectlyByAtomicReadAndNonAtomicWrite:(id)object
//{
//	
//}

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
