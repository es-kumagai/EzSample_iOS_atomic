//
//  EzSampleViewController.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EzSampleMenuTableViewController.h"

// テストの実行回数です。別のスレッドで絶え間なく書き込み中の値を、この回数だけ別スレッドから参照してデータが壊れるかを調べます。
#define EzSampleViewControllerTestStep 50000

// テストの選択と実行を行うビューコントローラーです。
@interface EzSampleViewController : UIViewController

@property (nonatomic,readonly,weak) IBOutlet UITextView* logTextView;
@property (nonatomic,readonly,weak) IBOutlet UITextView* reportTextView;
@property (nonatomic,readonly,weak) IBOutlet UIProgressView* progressView;

@property (nonatomic,readonly,strong) IBOutlet EzSampleMenuTableViewController* menuTableViewController;

- (void)clearOutputs;

@end
