//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"
#import "WZMTransGifViewController.h"

@interface ThirdViewController ()<WZMAlbumNavigationControllerDelegate,WZMDownloaderDelegate>

@end

@implementation ThirdViewController {
    UIImageView *_imageView;
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 200.0, 100.0, 50.0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"hhaah" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)downloader:(WZMDownloader *)downloader didWriteBytes:(int64_t)didWriteBytes totalBytes:(int64_t)totalBytes {
    NSLog(@"%@",@(didWriteBytes*1.0/totalBytes));
}
- (void)downloader:(WZMDownloader *)downloader didFinish:(NSString *)path error:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)btnClick:(UIButton *)btn {
    
    NSString *str = @"https://r3---sn-n4v7knls.googlevideo.com/videoplayback?expire=1606917198&ei=7kfHX4O7FZOVkwbX9J6wCg&ip=47.88.90.51&id=o-AJhcd8hk0yM3TJTWCX-qfvWcv7fR9pwjF1HaHLYqAnpG&itag=137&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278&source=youtube&requiressl=yes&mh=Dg&mm=31%2C29&mn=sn-n4v7knls%2Csn-n4v7sn7z&ms=au%2Crdu&mv=u&mvi=3&pl=23&vprv=1&mime=video%2Fmp4&ns=mV82Z_IQ2Fau3gJAmM0Xh28F&gir=yes&clen=51532237&dur=261.699&lmt=1600529757161283&mt=1606895068&fvip=3&keepalive=yes&c=WEB&txp=5432432&n=MpNQIQNWsq2-nLjVt&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIgMcRFnInhlOdL8FDd3_tvRVYVS2S8lXztagSqgObVPaACIQDaleO7VkN3x2HiRN2onYfQ2-mnFCOFL9r2Uu6vpR0iWA%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl&lsig=AG3C_xAwRQIhAPXpdTyWkbHzUUZYpoHG-xK_YBQrSycG_VdzJnZkkyyEAiAGJ0tDNgsBKOlnkz22lnQsI8BozJ8lWLwIXiD8el-RNA%3D%3D";
    
    static WZMDownloader *downloader;
    downloader = [[WZMDownloader alloc] init];
    downloader.url = str;
    downloader.delegate = self;
    [downloader start];
}

@end
