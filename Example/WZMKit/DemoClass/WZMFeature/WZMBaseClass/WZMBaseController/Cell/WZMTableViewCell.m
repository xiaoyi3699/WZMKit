//
//  WZMTableViewCell.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/10/16.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMTableViewCell.h"

@implementation WZMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    UIColor *dColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:DARK_COLOR];
    self.backgroundColor = dColor;
    self.contentView.backgroundColor = dColor;
}

@end
