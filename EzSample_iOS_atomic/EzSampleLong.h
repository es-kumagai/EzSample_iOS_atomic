//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSampleObjectProtocol.h"

@interface EzSampleLong : NSObject <EzSampleObjectProtocol>
{
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite) long valueForReplaceByNonAtomic;
@property (atomic,readwrite) long valueForReplaceByAtomic;
@property (atomic,readonly) long valueForReplaceByAtomicReadAndNonAtomicWrite;

@property (nonatomic,readonly) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

- (BOOL)outputStructState:(long)value withLabel:(NSString*)label;

@end
