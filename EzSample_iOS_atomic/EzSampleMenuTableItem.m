//
//  EzSampleMenuTableItem.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleMenuTableItem.h"

@implementation EzSampleMenuTableItem

- (id)initWithTestClassName:(NSString *)testClassName description:(NSString *)description
{
	self = [super init];
	
	if (self)
	{
		self.testClassName = testClassName;
		self.description = description;
	}
	
	return self;
}

@end
