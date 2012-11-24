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

@interface EzSampleClassAssign : NSObject <EzSampleObjectProtocol>
{
	@public
	
	EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
	
	NSThread* _threadForValueForReplaceByNonAtomic;
	NSThread* _threadForValueForReplaceByAtomic;
	NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
	
	NSUInteger _loggingCountForReplaceByAtomic;
	NSUInteger _loggingCountForReplaceByNonAtomic;
	NSUInteger _loggingCountForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,assign) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@property (nonatomic,readwrite) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByNonAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomicReadAndNonAtomicWrite;

- (BOOL)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label;

@end
