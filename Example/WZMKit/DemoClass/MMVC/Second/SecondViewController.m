//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate>

@end

@implementation SecondViewController {
    NSInteger _time;
}

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
    
//    NSString *url = @"http://www.ct918.com/api/mobile/address!listAll.do";
//    [[WZMNetWorking netWorking] GET:url parameters:nil callBack:^(id responseObject, NSError *error) {
//        NSDictionary *data = [WZMJSONParse getDictionaryValueInDict:responseObject withKey:@"data"];
//        NSArray *list = [WZMJSONParse getArrayValueInDict:data withKey:@"list"];
//        NSString *cityPlist = [NSString stringWithFormat:@"%@/city.plist",NSHomeDirectory()];
//        [WZMFileManager writeFile:list toPath:cityPlist];
//    }];
//    NSLog(@"%@",NSHomeDirectory());
//
//    return;
//    NSString *str1 = @"重庆";
//    NSString *str = @"%u91CD%u5E86";
//    NSLog(@"%@==%@",[str wzm_getURLDecoded],[str1 wzm_getURLEncoded2]);
//    return;
    
    WZMAlbumConfig *config = [WZMAlbumConfig new];
    config.originalVideo = YES;
    config.originalImage = YES;
    config.allowShowGIF = YES;
    config.maxCount = 20;
    config.allowPreview = YES;
    config.allowDragSelect = NO;
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    NSLog(@"===%@===%@===%@",originals,thumbnails,assets);
}

@end
