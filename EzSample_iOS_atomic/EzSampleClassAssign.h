//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassAssign : EzSampleClassBase

@property (nonatomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,assign) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,assign) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@end
