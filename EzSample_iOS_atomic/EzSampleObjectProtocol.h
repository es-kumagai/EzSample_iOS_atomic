//
//  EzSampleObjectProtocol.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>

// テスト経過を UI に反映させたい場合は、これらの Notification を使用します。どのスレッドからでも送信できます。
#define EzPostClear [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAR" object:nil]
#define EzPostMark EzPostLog(@"------------")
#define EzPostLog(message,...) [[NSNotificationCenter defaultCenter] postNotificationName:@"LOG" object:[NSString stringWithFormat:message, ##__VA_ARGS__]]
#define EzPostReport(message,...) [[NSNotificationCenter defaultCenter] postNotificationName:@"REPORT" object:[NSString stringWithFormat:message, ##__VA_ARGS__]]
#define EzPostProgress(value) [[NSNotificationCenter defaultCenter] postNotificationName:@"PROGRESS" object:[NSNumber numberWithInt:value]]

// 構造体を「値」としてテストする際に使用します。
struct EzSampleObjectStructValue
{
	int a;
	int b;
};

// テストを実行するクラスが実装すべき機能です。
@protocol EzSampleObjectProtocol <NSObject>

@required

- (void)start;		// 「値」の書き込みループを開始します。
- (void)stop;		// 「値」の書き込みループを終了します。

- (void)output;				// 「値」を参照し、矛盾があるかどうかをログに記録します。
- (void)outputLoopCount;	// 「値」を書き込んだ回数の総計をレポートに記録します。

@end
