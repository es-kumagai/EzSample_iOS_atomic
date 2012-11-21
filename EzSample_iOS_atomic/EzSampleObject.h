//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>

struct EzSampleObjectStructValue
{
	int a;
	int b;
};

@interface EzSampleObject : NSObject
{
//	struct EzSampleObjectStructValue _valueForDirectlyByAtomicReadAndNonAtomicWrite;
	struct EzSampleObjectStructValue _valueForReplaceByAtomicReadAndNonAtomicWrite;
	
	__strong NSThread* _threadForInternalOutput;
	
//	__strong NSThread* _threadForValueForDirectlyByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
//	__strong NSThread* _threadForValueForDirectlyByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
//	__strong NSThread* _threadForValueForDirectlyByAtomicReadAndNonAtomicWrite;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
}

//@property (nonatomic,readwrite) struct EzSampleObjectStructValue valueForDirectlyByNonAtomic;
@property (nonatomic,readwrite) struct EzSampleObjectStructValue valueForReplaceByNonAtomic;

//@property (atomic,readwrite) struct EzSampleObjectStructValue valueForDirectlyByAtomic;
@property (atomic,readwrite) struct EzSampleObjectStructValue valueForReplaceByAtomic;

//@property (atomic,readonly) struct EzSampleObjectStructValue valueForDirectlyByAtomicReadAndNonAtomicWrite;
@property (atomic,readonly) struct EzSampleObjectStructValue valueForReplaceByAtomicReadAndNonAtomicWrite;

//@property (nonatomic,readonly) int loopCountOfValueForDirectlyByNonAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByNonAtomic;
//@property (nonatomic,readonly) int loopCountOfValueForDirectlyByAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomic;
//@property (nonatomic,readonly) int loopCountOfValueForDirectlyByAtomicReadAndNonAtomicWrite;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

- (void)start;
- (void)stop;

+ (void)outputStructState:(struct EzSampleObjectStructValue)value withLabel:(NSString*)label;

@end
