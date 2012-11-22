//
//  EzSampleViewController.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EzSampleViewControllerTestStep 250

@interface EzSampleViewController : UIViewController

@property (nonatomic,readonly,weak) IBOutlet UITextView* logTextView;
@property (nonatomic,readonly,weak) IBOutlet UITextView* reportTextView;
@property (nonatomic,readonly,weak) IBOutlet UIProgressView* progressView;
@property (nonatomic,readonly,weak) IBOutlet UIScrollView* menuScrollView;

- (void)clearOutputs;

@end
