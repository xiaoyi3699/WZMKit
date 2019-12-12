//
//  ZMCaptionViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ZMCaptionViewController.h"
#import "WZMVideoEditView.h"

@interface ZMCaptionViewController ()

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WZMVideoEditView *videoView;
@property (nonatomic, strong) UIView *toolView;

@end

@implementation ZMCaptionViewController

- (instancetype)initWithVideoUrl:(NSURL *)videoUrl {
    self = [super init];
    if (self) {
        self.videoUrl = videoUrl;
        self.title = @"添加字幕";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WZM_R_G_B(244, 244, 244);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportVideo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat toolViewH = 140;
    CGRect rect = WZMRectBottomArea();
    rect.origin.y += 10;
    rect.size.height -= toolViewH+20;
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.scrollView];
    
    [self initVideoView];
    [self loadCaptionWords];
    [self initToolView:toolViewH];
}

//播放view
- (void)initVideoView {
    self.videoView = [[WZMVideoEditView alloc] initWithFrame:self.scrollView.bounds];
    self.videoView.videoUrl = self.videoUrl;
    [self.scrollView addSubview:self.videoView];
}

//底部面板view
- (void)initToolView:(CGFloat)toolViewH {
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.wzm_maxY+10, self.view.wzm_width, toolViewH)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
}

//加载歌词
- (void)loadCaptionWords {
    //初始化歌词
    WZMCaptionModel *noteModel = [[WZMCaptionModel alloc] init];
    noteModel.text = @"我是第一个字幕:啦啦啦啦啦啦";
    noteModel.textColor = [UIColor whiteColor];
    noteModel.highTextColor = [UIColor redColor];
    noteModel.textPosition = CGPointMake(10, 10);
    noteModel.startTime = 0.5;
    noteModel.duration = 1.5;
    noteModel.textType = WZMCaptionModelTypeGradient;
    noteModel.textAnimationType = WZMCaptionTextAnimationTypeOneByOne;
    noteModel.showNote = NO;
    noteModel.noteId = @"1";
    
    WZMCaptionModel *noteModel2 = [[WZMCaptionModel alloc] init];
    noteModel2.text = @"我是第二个字幕:啦啦啦啦啦啦";
    noteModel2.textColor = [UIColor greenColor];
    noteModel2.highTextColor = [UIColor blueColor];
    noteModel2.textPosition = CGPointMake(10, 10);
    noteModel2.startTime = 2.5;
    noteModel2.duration = 2.5;
    noteModel2.noteId = @"2";
    
    WZMCaptionModel *noteModel3 = [[WZMCaptionModel alloc] init];
    noteModel3.text = @"我是第三个字幕:啦啦啦啦啦啦";
    noteModel3.textColor = [UIColor blueColor];
    noteModel3.highTextColor = [UIColor greenColor];
    noteModel3.textPosition = CGPointMake(10, 10);
    noteModel3.startTime = 5.5;
    noteModel3.duration = 3.5;
    noteModel3.noteId = @"3";
    
    self.videoView.noteModels = @[noteModel,noteModel2,noteModel3];
}

//导出视频
- (void)exportVideo {
    if (self.videoView.exporting) return;
    [WZMViewHandle wzm_showProgressMessage:nil];
    [self.videoView exportVideoWithNoteAnimationCompletion:^(NSURL *exportURL) {
        [WZMViewHandle wzm_dismiss];
        if (exportURL) {
            [WZMAlbumHelper wzm_saveVideo:exportURL.path];
        }
    }];
}

@end
