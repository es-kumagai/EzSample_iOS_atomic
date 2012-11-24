//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

@interface EzSampleClassNonARC : EzSampleClassBase

@property (nonatomic,readwrite,retain) EzSampleObjectClassValue* valueForReplaceByNonAtomic;
@property (atomic,readwrite,retain) EzSampleObjectClassValue* valueForReplaceByAtomic;
@property (atomic,readonly,retain) EzSampleObjectClassValue* valueForReplaceByAtomicReadAndNonAtomicWrite;

@end
