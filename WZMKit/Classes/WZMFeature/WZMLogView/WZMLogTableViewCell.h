//
//  WZMLogTableViewCell.h
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2018/9/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMLogModel.h"

@interface WZMLogTableViewCell : UITableViewCell

- (instancetype)initWithWidth:(CGFloat)width style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setConfig:(WZMLogModel *)model;

@end
