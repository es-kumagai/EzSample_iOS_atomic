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


#define EzSampleClassOutputHeaderFormat @"%-15s : %@"

static const char* EzSampleClassCLabelForAtomic = "ATOMIC";
static const char* EzSampleClassCLabelForNonAtomic = "NONATOMIC";
static const char* EzSampleClassCLabelForAtomicReadAndNonAtomicWrite = "R:ATOM-W:DIRECT";

__strong static NSString* EzSampleClassLabelForAtomic = @"ATOMIC";
__strong static NSString* EzSampleClassLabelForNonAtomic = @"NONATOMIC";
__strong static NSString* EzSampleClassLabelForAtomicReadAndNonAtomicWrite = @"R:ATOM-W:DIRECT";


typedef NS_ENUM(NSInteger, EzSampleClassTestCase)
{
	EzSampleClassTestCaseAtomic = 0,
	EzSampleClassTestCaseNonAtomic = 1,
	EzSampleClassTestCaseAtomicReadAndNonAtomicWrite = 2
};

typedef NS_ENUM(NSInteger, EzSampleClassResultState)
{
	EzSampleClassResultStateInconsistent = -1,
	EzSampleClassResultStateWeakNil = 0,
	EzSampleClassResultStateOK = 1
};


struct EzSampleClassOutputStruct
{
	const char* label;
	int loopCount;
	BOOL inconsistent;
	BOOL weakNil;
	char* errorMessage;
	BOOL skip;
};

@interface EzSampleClassBase : NSObject <EzSampleObjectProtocol>
{
@protected
	
	__strong NSThread* _threadForValueForReplaceByNonAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomic;
	__strong NSThread* _threadForValueForReplaceByAtomicReadAndNonAtomicWrite;
	
	NSUInteger _loggingCountForReplaceByAtomic;
	NSUInteger _loggingCountForReplaceByNonAtomic;
	NSUInteger _loggingCountForReplaceByAtomicReadAndNonAtomicWrite;
	
	__strong NSNumberFormatter* _formatter;
}

@property (atomic,readwrite,copy) NSString* stateStringForNil;		// 既定値は @"NG" です。nil 時に成功とする場合は nil を設定します。

@property (nonatomic,readwrite) int loopCountOfValueForReplaceByNonAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomic;
@property (nonatomic,readwrite) int loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL inconsistentReplaceByNonAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomic;
@property (atomic,readwrite) BOOL inconsistentReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL weakNilReplaceByNonAtomic;
@property (atomic,readwrite) BOOL weakNilReplaceByAtomic;
@property (atomic,readwrite) BOOL weakNilReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL badAccessReplaceByNonAtomic;
@property (atomic,readwrite) BOOL badAccessReplaceByAtomic;
@property (atomic,readwrite) BOOL badAccessReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite) BOOL skipLogReplaceByNonAtomic;
@property (atomic,readwrite) BOOL skipLogReplaceByAtomic;
@property (atomic,readwrite) BOOL skipLogReplaceByAtomicReadAndNonAtomicWrite;

@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByNonAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomic;
@property (atomic,readwrite,copy) NSString* errorMessageForReplaceByAtomicReadAndNonAtomicWrite;


- (EzSampleClassResultState)outputStructState:(__unsafe_unretained EzSampleObjectClassValue*)value withLabel:(const char*)label;
- (void)outputLoopCount;

- (struct EzSampleClassOutputStruct)getCreatedOutputStructForState:(EzSampleClassTestCase)state;
- (void)releaseOutputStruct:(const struct EzSampleClassOutputStruct*)structData;

#pragma mark -
#pragma mark 必要に応じてオーバーライドします。

- (void)outputLoopCountForState:(EzSampleClassTestCase)state;

#pragma mark -
#pragma mark オーバーライドしてテスト処理を完成させる必要があります。

- (void)testForAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat;
- (void)testForNonAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat;
- (void)testForAtomicReadAndNonAtomicWriteWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat;

- (EzSampleClassResultState)outputValueForAtomic;
- (EzSampleClassResultState)outputValueForNonAtomic;
- (EzSampleClassResultState)outputValueForAtomicReadAndNonAtomicWrite;

@end
