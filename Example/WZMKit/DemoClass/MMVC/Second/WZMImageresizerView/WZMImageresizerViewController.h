//
//  ViewController.h
//  Image
//
//  Created by aasjdi dau on 2019/3/27.
//  Copyright © 2019 aasjdi dau. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LVImageBlock)(UIImage *image);
@interface WZMImageresizerViewController : UIViewController

/**
 是否是原图
 */
@property (nonatomic) BOOL original;
@property (nonatomic, strong) UIColor *navItemColor;
@property (nonatomic, strong) UIColor *themeItemColor;

- (instancetype)initWithImage:(UIImage *)image completion:(LVImageBlock)completion;

@end
