//
//  LJJLBSManager.h
//  RACDemo
//
//  Created by liujunjie on 2019/3/26.
//  Copyright © 2019 刘俊杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LJJLBSManager;
@protocol LJJLBSManagerDelegate <NSObject>

@optional
- (void)getLbsSuccessWithLongitude:(NSString *)longitude latitude:(NSString *)latitude;

@end

@interface LJJLBSManager : NSObject
@property (nonatomic, assign) id<LJJLBSManagerDelegate>delegate;

+ (LJJLBSManager *)startGetLBSWithDelegate:(id<LJJLBSManagerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
