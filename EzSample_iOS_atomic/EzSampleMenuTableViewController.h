//
//  EzSampleMenuTableViewController.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EzSampleMenuViewControllerDelegate.h"

// テスト項目を管理し、テスト項目を選ばせたり、テストクラスのインスタンスをデリゲートを通して通知します。
@interface EzSampleMenuTableViewController : UITableViewController

@property (nonatomic,readwrite,weak) IBOutlet id<EzSampleMenuViewControllerDelegate> delegate;

@end
