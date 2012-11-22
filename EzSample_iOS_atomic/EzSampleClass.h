//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSampleObjectProtocol.h"
#import "EzSampleObjectClassValue.h"

@interface EzSampleClass : NSObject <EzSampleObjectProtocol>
{
	EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
	
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
	
	NSUInteger _loggingCountForReplaceByAtomic;
	NSUInteger _loggingCountForReplaceByNonAtomic;
}

@property (nonatomic,readwrite,strong) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,strong) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,strong) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@property (nonatomic,readonly) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readonly) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

- (BOOL)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label;

@end
