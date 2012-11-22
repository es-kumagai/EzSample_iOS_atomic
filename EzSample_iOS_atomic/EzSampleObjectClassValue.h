//
//  EzSampleObjectClassValue.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>

// Objective-C インスタンスの原子性テストを行うときに使用する「値」です。
@interface EzSampleObjectClassValue : NSObject <NSCopying>
{
	@public
	
	int a;
	int b;
	
	__strong NSString* _label;
}

- (id)initWithLabel:(NSString*)label;

+ (void)setLogTargetThread:(NSThread*)targetThread;
+ (NSThread*)logTargetThread;

@end
