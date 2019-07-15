//
//  LLPhotoBrowser.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPhotoBrowserCell.h"

@protocol LLPhotoBrowserDelegate;

@interface LLPhotoBrowser : UIViewController

@property (nonatomic, weak) id<LLPhotoBrowserDelegate> delegate;

///images内的元素，可以是UIImage对象、NSData对象、路径、图片网址，并且支持gif
@property (nonatomic, strong) NSArray *images;
///图片索引
@property (nonatomic, assign) NSInteger index;

@end

@protocol LLPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser
        clickAtIndex:(NSInteger)index
             content:(id)content
               isGif:(BOOL)isGif
                type:(LLGestureRecognizerType)type;


@end
