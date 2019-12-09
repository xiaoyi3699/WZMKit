//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMVideoEditView.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *noteView;

@end

@implementation SecondViewController {
    NSInteger _time;
    WZMVideoEditView *editView;
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
    
    editView = [[WZMVideoEditView alloc] initWithFrame:CGRectMake(10, 100, 355, 400)];
    editView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:editView];
    
    NSArray *titles = @[@"导入视频",@"导入歌词",@"生成视频"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*100, 560, 80, 40)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        WZMAlbumConfig *config = [WZMAlbumConfig new];
        config.originalVideo = YES;
        config.originalImage = YES;
        config.allowShowGIF = YES;
        config.maxCount = 1;
        config.allowPreview = YES;
        config.allowDragSelect = NO;
        config.allowShowImage = NO;
        WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
        vc.pickerDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (btn.tag == 1) {
        if (editView.noteModels) return;
        
        WZMNoteModel *noteModel = [[WZMNoteModel alloc] init];
        noteModel.text = @"我是第一个字幕:啦啦啦啦啦啦";
        noteModel.textColor = [UIColor whiteColor];
        noteModel.highTextColor = [UIColor redColor];
        noteModel.textPosition = CGPointMake(2, 40);
        noteModel.startTime = 1.0;
        noteModel.duration = 2;
        noteModel.angle = 20;
        noteModel.textType = WZMNoteModelTypeGradient;
        noteModel.textAnimationType = WZMNoteTextAnimationTypeOneByOne;
        noteModel.showNote = NO;
        
        WZMNoteModel *noteModel2 = [[WZMNoteModel alloc] init];
        noteModel2.text = @"我是第二个字幕:啦啦啦啦啦啦";
        noteModel2.textColor = [UIColor greenColor];
        noteModel2.highTextColor = [UIColor blueColor];
        noteModel2.textPosition = CGPointMake(2, 2);
        noteModel2.startTime = 4.0;
        noteModel2.duration = 3;
        
        WZMNoteModel *noteModel3 = [[WZMNoteModel alloc] init];
        noteModel3.text = @"我是第三个字幕:啦啦啦啦啦啦";
        noteModel3.textColor = [UIColor blueColor];
        noteModel3.highTextColor = [UIColor greenColor];
        noteModel3.textPosition = CGPointMake(2, 2);
        noteModel3.startTime = 8.0;
        noteModel3.duration = 4;
        
        editView.noteModels = @[noteModel,noteModel2,noteModel3];
    }
    else {
        [WZMViewHandle wzm_showProgressMessage:nil];
        [editView exportVideoWithNoteAnimationCompletion:^(NSURL *exportURL) {
            [WZMViewHandle wzm_dismiss];
            if (exportURL) {
                [WZMAlbumHelper wzm_saveVideo:exportURL.path];
            }
        }];
    }
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    editView.videoUrl = originals.firstObject;
}

@end
