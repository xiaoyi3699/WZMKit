//
//  WZMTransGifViewController.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/11/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//  图片转gif

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMTransGifViewController : UIViewController

///images内元素类型:NSURL,NSString,UIImage(路径或图片名或UIImage对象)
- (instancetype)initWithImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
