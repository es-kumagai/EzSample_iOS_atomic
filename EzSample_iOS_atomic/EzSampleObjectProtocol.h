//
//  EzSampleObjectProtocol.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EzPostClear [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAR" object:nil]
#define EzPostMark EzPostLog(@"------------")
#define EzPostLog(message,...) [[NSNotificationCenter defaultCenter] postNotificationName:@"LOG" object:[[NSString alloc] initWithFormat:message, ##__VA_ARGS__]]
#define EzPostReport(message,...) [[NSNotificationCenter defaultCenter] postNotificationName:@"REPORT" object:[[NSString alloc] initWithFormat:message, ##__VA_ARGS__]]
#define EzPostProgress(value) [[NSNotificationCenter defaultCenter] postNotificationName:@"PROGRESS" object:[[NSNumber alloc] initWithInt:value]]

struct EzSampleObjectStructValue
{
	int a;
	int b;
};

@protocol EzSampleObjectProtocol <NSObject>

@required

- (void)start;
- (void)stop;

- (void)outputWithLabel:(NSString*)label;
- (void)outputLoopCount;

@end
