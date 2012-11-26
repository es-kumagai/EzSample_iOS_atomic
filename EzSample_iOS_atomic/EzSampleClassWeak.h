//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassWeak : EzSampleClassBase
{
	@protected
	
	__weak EzSampleObjectClassValue* _valueForReplaceByAtomic;
	__weak EzSampleObjectClassValue* _valueForReplaceByNonAtomic;
	__weak EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite,weak) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,weak) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,weak) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@end
