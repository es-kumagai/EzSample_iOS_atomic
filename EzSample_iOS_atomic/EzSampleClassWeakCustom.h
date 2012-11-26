//
//  EzSampleObject.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassWeak.h"

@interface EzSampleClassWeakCustom : EzSampleClassWeak
{
	__strong NSLock* _lock;
}

@end
