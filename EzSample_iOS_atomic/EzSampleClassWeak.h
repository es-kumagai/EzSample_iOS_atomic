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

typedef NS_ENUM(NSInteger, EzSampleClassWeakState)
{
	EzSampleClassWeakStateInconsistent = -1,
	EzSampleClassWeakStateWeakNil = 0,
	EzSampleClassWeakStateOK = 1
};

@interface EzSampleClassWeak : NSObject <EzSampleObjectProtocol>
{
	@public
	
	__weak EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
	
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
	
	NSUInteger _loggingCountForReplaceByAtomic;
	NSUInteger _loggingCountForReplaceByNonAtomic;
	NSUInteger _loggingCountForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite,weak) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,weak) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,weak) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@property (nonatomic,readwrite) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL weakNilReplaceByNonAtomic;
@property (atomic,readwrite) BOOL weakNilReplaceByAtomic;
@property (atomic,readwrite) BOOL weakNilReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByNonAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomicReadAndNonAtomicWrite;

- (EzSampleClassWeakState)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label;

@end
