//
//  LLLogModel.m
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2018/9/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLLogModel.h"
#import "NSString+LLAddPart.h"

@implementation LLLogModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = -1;
    }
    return self;
}

- (NSInteger)setConfigWithWidth:(NSInteger)width font:(UIFont *)font {
    if (self.height == -1) {
        self.height = MAX(ceil([NSString ll_heightWithStr:self.text width:width font:font]), 44);
    }
    return self.height;
}

@end
