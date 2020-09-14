//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"
#import "WZMAlertQueue.h"
#import <Photos/Photos.h>
@interface ThirdViewController ()<WZMAlbumNavigationControllerDelegate>

@end

@implementation ThirdViewController {
    WZMShadowLabel *_shadowLabel;
    WZMShadowLayer *_shadowLayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第三页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[WZMAlertQueue shareQueue] showAlertView:alertView];
    
    WZMAlertView *alertView2 = [[WZMAlertView alloc] initWithTitle:@"提示" message:@"你还好吗" OKButtonTitle:@"确定" cancelButtonTitle:@"取消" type:WZMAlertViewTypeNormal];
    [[WZMAlertQueue shareQueue] showAlertView:alertView2];
    
    UIAlertView *alertView3 = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[WZMAlertQueue shareQueue] showAlertView:alertView3];
    
    WZMAlertView *alertView4 = [[WZMAlertView alloc] initWithTitle:@"提示" message:@"你还好吗" OKButtonTitle:@"确定" cancelButtonTitle:@"取消" type:WZMAlertViewTypeNormal];
    [[WZMAlertQueue shareQueue] showAlertView:alertView4];
    
    WZMAlertView *alertView5 = [[WZMAlertView alloc] initWithTitle:@"提示" message:@"你还好吗" OKButtonTitle:@"确定" cancelButtonTitle:@"取消" type:WZMAlertViewTypeNormal];
    [[WZMAlertQueue shareQueue] showAlertView:alertView5];
    
    UIAlertView *alertView6 = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[WZMAlertQueue shareQueue] showAlertView:alertView6];
    
    UIAlertView *alertView7 = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[WZMAlertQueue shareQueue] showAlertView:alertView7];
    
//    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
//    WZMAlbumNavigationController *albumNav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
//    albumNav.pickerDelegate = self;
//    [self presentViewController:albumNav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    
}

@end
