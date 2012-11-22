//
//  EzSampleMenuTableItem.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <Foundation/Foundation.h>

// テスト項目をひとつひとつ管理します。
@interface EzSampleMenuTableItem : NSObject

- (id)initWithTestClassName:(NSString*)testClassName description:(NSString*)description;

@property (nonatomic,readwrite,copy) NSString* description;
@property (nonatomic,readwrite,copy) NSString* testClassName;

@end
