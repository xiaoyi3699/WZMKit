//
//  UILabel+wzmcate.m
//  WZMFoundation
//
//  Created by Mr.Wang on 16/12/21.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UILabel+wzmcate.h"

@implementation UILabel (wzmcate)

- (void)wzm_textGradientColors:(NSArray *)colors gradientType:(WZMGradientType)type {
    
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors) {
        [CGColors addObject:(id)color.CGColor];
    }
    
    //创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    gradientLayer.colors = CGColors;
//    gradientLayer.locations = @[@0.0, @1.0];
    if (type == WZMGradientTypeLeftToRight) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    }
    else if (type == WZMGradientTypeTopToBottom) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    }
    else if (type == WZMGradientTypeUpleftToLowright) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    }
    else {
        gradientLayer.startPoint = CGPointMake(1.0, 0.0);
        gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    }
    [self.superview.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = self.layer;
    self.frame = gradientLayer.bounds;
}

- (void)wzm_textGradientColorWithGradientType:(WZMGradientType)type {
    NSMutableArray *colorArray = [NSMutableArray new];
    for (NSInteger hue = 0; hue < 255; hue += 5) {
        UIColor *color = [UIColor colorWithHue:hue/255.0
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colorArray addObject:color];
    }
    [self wzm_textGradientColors:colorArray gradientType:type];
}

@end
