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
	
	int valid;		// init 時に 0、dealloc 時に -1 にして、直接参照することで、強引に dealloc されたかを判定します。正しい解が得られないこともあるかもしれません。BAD ACCESS になるかもしれません。
	
	@private
	
	__strong NSString* _label;
	NSUInteger _serial;
}

- (id)initWithLabel:(NSString*)label;

+ (void)setLogTargetThread:(NSThread*)targetThread;
+ (NSThread*)logTargetThread;
+ (void)setLoggingForce:(BOOL)force;
+ (BOOL)loggingForce;

@end
