//
//  EzSampleMenuTableViewCell.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EzSampleMenuTableItem.h"

// テスト項目を画面に表示するためのセルです。
@interface EzSampleMenuTableViewCell : UITableViewCell

@property (nonatomic,readonly,weak) IBOutlet UILabel* numberLabel;
@property (nonatomic,readonly,weak) IBOutlet UILabel* descriptionLabel;
@property (nonatomic,readonly,weak) IBOutlet UILabel* testClassNameLabel;

- (void)setItem:(EzSampleMenuTableItem*)item;
- (void)setNumber:(NSUInteger)number;

@end
