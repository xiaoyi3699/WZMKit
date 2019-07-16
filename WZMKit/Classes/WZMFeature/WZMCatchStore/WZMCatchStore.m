//
//  WZMCatchStore.m
//  WZMFeatureStatic
//
//  Created by WangZhaomeng on 2018/9/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMCatchStore.h"

@interface WZMCatchStore ()

@property (strong, nonatomic) NSMutableDictionary *data;

@end

@implementation WZMCatchStore

+ (instancetype)store {
    static WZMCatchStore *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[WZMCatchStore alloc] init];
        store.data = [[NSMutableDictionary alloc] init];
    });
    return store;
}

- (void)setObj:(id)obj forKey:(NSString *)key {
    if (key.length && obj) {
        [self.data setValue:obj forKey:key];
    }
}

- (id)objForKey:(NSString *)key {
    if (key.length) {
        return [self.data objectForKey:key];
    }
    return nil;
}

@end
