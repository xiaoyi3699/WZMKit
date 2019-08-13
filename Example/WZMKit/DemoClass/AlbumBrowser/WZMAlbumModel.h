//
//  WZMAlbumModel.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMEnum.h"

@interface WZMAlbumModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign) WZMAlbumPhotoType type;

+ (instancetype)modelWithAsset:(id)asset;

@end
