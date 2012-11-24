//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassCopy : EzSampleClassBase
{
	EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;	
}

@property (nonatomic,readwrite,copy) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,copy) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,copy) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@end
