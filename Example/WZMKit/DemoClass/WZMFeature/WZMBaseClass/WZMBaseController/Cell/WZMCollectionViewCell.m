//
//  WZMCollectionViewCell.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/10/16.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMCollectionViewCell.h"

@implementation WZMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    UIColor *dColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:WZM_DARK_COLOR];
    self.backgroundColor = dColor;
    self.contentView.backgroundColor = dColor;
}

@end
