//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMAlbumController.h"
#import "WZMAlbumNavigationController.h"
#import <WZMKit/WZMKit.h>

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate> {
    WZMPlayer *player;
}

@end

@implementation SecondViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config.json(1).encode" ofType:nil];
    NSLog(@"%@",[self decodeJSONWithPath:path]);
}

//解码文件
- (NSString *)decodeJSONWithPath:(NSString *)path {
    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if ([str hasPrefix:@"{"]) {
        return str;
    }
    return [self decodeString:[str wzm_base64DecodedString]];
}

//解码字符串
- (NSString *)decodeString:(NSString *)encodeString {
    NSString *pre = [encodeString substringToIndex:8];
    NSString *key = @"";
    int lastP = [[pre substringFromIndex:pre.length-1] intValue];
    for (NSInteger pIndex = 0; pIndex < pre.length-1; pIndex++) {
        unichar p = [pre characterAtIndex:pIndex]-lastP;
        NSString *str = [NSString stringWithFormat:@"%c",p];
        key = [key stringByAppendingString:str];
    }
    key = [key stringByAppendingString:[NSString stringWithFormat:@"%@",@(lastP)]];
    NSString *suf = [encodeString substringFromIndex:8];
    NSString *result = @"";
    for (NSInteger sIndex = 0; sIndex < suf.length; sIndex++) {
        unichar p = [key characterAtIndex:(sIndex%pre.length)];
        unichar s = [suf characterAtIndex:sIndex];
        NSString *str = [NSString stringWithFormat:@"%c",(s^p)];
        result = [result stringByAppendingString:str];
    }
    return [result wzm_base64DecodedString];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
//    config.allowPreview = YES;
//    config.maxCount = 20;
//
//    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
//    vc.pickerDelegate = self;
//    [self presentViewController:vc animated:YES completion:nil];

//    WZMAlbumController *vc = [[WZMAlbumController alloc] initWithConfig:config];
//    vc.pickerDelegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

- (void)albumController:(WZMAlbumController *)albumController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

@end
