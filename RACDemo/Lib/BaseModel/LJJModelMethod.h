//
//  LJJModelMethod.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LJJModelMethod <NSObject>

@required //必须
- (void)networkRequest;//网络请求

@optional  //可选
- (id)dataRreating:(id)anyObject;//数据处理
@end

NS_ASSUME_NONNULL_END
