//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassAssignCustomWithARC : EzSampleClassBase
{
@protected
	
	__unsafe_unretained EzSampleObjectClassValue* _valueForReplaceByAtomic;
	__unsafe_unretained EzSampleObjectClassValue* _valueForReplaceByNonAtomic;
	__unsafe_unretained EzSampleObjectClassValue* _valueForReplaceByAtomicReadAndNonAtomicWrite;
}

@property (nonatomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,assign) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

//- (void)setValueForReplaceByAtomic:(__unsafe_unretained EzSampleObjectClassValue *)valueForReplaceByAtomic;
//- (EzSampleObjectClassValue*)valueForReplaceByAtomic NS_RETURNS_INNER_POINTER;

@end
