//
//  WZMEditerModel.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/8/25.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WZMEditerModel : NSObject

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVAssetTrack *audio;
@property (nonatomic, strong) AVAssetTrack *video;
- (instancetype)initWithPath:(NSString *)path;

@end
