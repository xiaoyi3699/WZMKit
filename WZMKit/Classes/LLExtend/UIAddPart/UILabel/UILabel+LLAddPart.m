//
//  UILabel+LLAddPart.m
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/21.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UILabel+LLAddPart.h"

@implementation UILabel (LLAddPart)
/*
+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    [self myWillMoveToSuperview:newSuperview];
    //    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
    //        return;
    //    }
    if (self) {
        if (self.tag == 666) {
            self.font = [UIFont systemFontOfSize:self.font.pointSize];
        }
        else {
            self.font  = [UIFont WenYueQLTOfSize:self.font.pointSize];
        }
    }
}
*/

- (void)ll_textGradientColors:(NSArray *)colors gradientType:(LLGradientType)type {
    
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors) {
        [CGColors addObject:(id)color.CGColor];
    }
    
    //创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    gradientLayer.colors = CGColors;
//    gradientLayer.locations = @[@0.0, @1.0];
    if (type == LLGradientTypeLeftToRight) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    }
    else if (type == LLGradientTypeTopToBottom) {
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    }
    else if (type == LLGradientTypeUpleftToLowright) {
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

- (void)ll_textGradientColorWithGradientType:(LLGradientType)type {
    NSMutableArray *colorArray = [NSMutableArray new];
    for (NSInteger hue = 0; hue < 255; hue += 5) {
        UIColor *color = [UIColor colorWithHue:hue/255.0
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colorArray addObject:color];
    }
    [self ll_textGradientColors:colorArray gradientType:type];
}

@end
