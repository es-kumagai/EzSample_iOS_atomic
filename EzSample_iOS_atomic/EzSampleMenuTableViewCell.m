//
//  EzSampleMenuTableViewCell.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleMenuTableViewCell.h"

@implementation EzSampleMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNumber:(NSUInteger)number
{
	self.numberLabel.text = [[NSString alloc] initWithFormat:@"%02u", number];
}

- (void)setItem:(EzSampleMenuTableItem *)item
{
	self.descriptionLabel.text = item.description;
	self.testClassNameLabel.text = item.testClassName;
}

@end
