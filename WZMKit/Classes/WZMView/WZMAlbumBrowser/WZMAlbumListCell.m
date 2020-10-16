//
//  WZMAlbumListCell.m
//  KPoint
//
//  Created by WangZhaomeng on 2019/10/31.
//  Copyright © 2019 XiaoSi. All rights reserved.
//

#import "WZMAlbumListCell.h"
#import "UIColor+wzmcate.h"

@implementation WZMAlbumListCell {
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setConfig];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 60)];
        _titleLabel.textColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor darkTextColor] darkColor:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setConfig {
    UIColor *dColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0] darkColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];
    self.backgroundColor = dColor;
    self.contentView.backgroundColor = dColor;
}

- (void)setConfig:(UIImage *)image title:(NSString *)title {
    _imageView.image = image;
    _titleLabel.text = title;
}

@end
