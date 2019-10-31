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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 200, 44)];
        _titleLabel.textColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor darkTextColor] darkColor:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setConfig:(UIImage *)image title:(NSString *)title {
    _imageView.image = image;
    _titleLabel.text = title;
}

@end
