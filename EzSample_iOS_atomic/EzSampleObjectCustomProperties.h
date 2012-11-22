//
//  EzSampleObjectCustomProperties.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSampleObjectProtocol.h"

@interface EzSampleObjectCustomProperties : NSObject <EzSampleObjectProtocol>
{
	struct EzSampleObjectStructValue _valueForReplaceByNonAtomic;
	struct EzSampleObjectStructValue _valueForReplaceByAtomic;
	struct EzSampleObjectStructValue _valueForReplaceByAtomicReadAndNonAtomicWrite;
	
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite) struct EzSampleObjectStructValue valueForReplaceByNonAtomic;
@property (atomic,readwrite) struct EzSampleObjectStructValue valueForReplaceByAtomic;
@property (atomic,readonly) struct EzSampleObjectStructValue valueForReplaceByAtomicReadAndNonAtomicWrite;

@property (nonatomic,readonly) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

- (BOOL)outputStructState:(struct EzSampleObjectStructValue)value withLabel:(NSString*)label;

@end
