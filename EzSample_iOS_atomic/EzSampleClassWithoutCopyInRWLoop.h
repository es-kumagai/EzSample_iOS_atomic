//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassWithoutCopyInRWLoop : EzSampleClassBase
{
@protected
	
	__strong EzSampleObjectClassValue* _valueForReplaceByAtomic;
	__strong EzSampleObjectClassValue* _valueForReplaceByNonAtomic;
	__strong EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite,strong) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,strong) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,strong) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@end
