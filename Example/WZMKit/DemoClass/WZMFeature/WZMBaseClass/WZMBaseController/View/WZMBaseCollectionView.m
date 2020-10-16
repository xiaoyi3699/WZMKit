//
//  WZMBaseCollectionView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/28.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMBaseCollectionView.h"

@implementation WZMBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    self.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:DARK_COLOR];
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
