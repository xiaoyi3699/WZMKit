//
//  WZMLogModel.h
//  WZMKit
//
//  Created by WangZhaomeng on 2018/9/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMLogModel : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSInteger height;

- (NSInteger)setConfigWithWidth:(NSInteger)width font:(UIFont *)font;

@end
