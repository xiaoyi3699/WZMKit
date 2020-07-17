//
//  WZMButton.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/9/10.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMButton.h"

@implementation WZMButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleFrame = CGRectNull;
        self.imageFrame = CGRectNull;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGRectIsNull(self.imageFrame)) {
        return [super imageRectForContentRect:contentRect];
    }
    return self.imageFrame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectIsNull(self.titleFrame)) {
        return [super titleRectForContentRect:contentRect];
    }
    return self.titleFrame;
}

@end
