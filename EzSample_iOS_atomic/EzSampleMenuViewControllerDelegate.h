//
//  EzSampleMenuViewControllerDelegate.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSampleObjectProtocol.h"

@class EzSampleMenuViewController;

@protocol EzSampleMenuViewControllerDelegate <NSObject>

@required

- (void)EzSampleMenuViewController:(EzSampleMenuViewController*)menuViewController testButtonForTestInstancePushed:(id<EzSampleObjectProtocol>)testInstance;

@end
