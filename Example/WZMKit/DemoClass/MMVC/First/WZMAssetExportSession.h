//
//  WZMAssetExportSession.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/11.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@protocol WZMAssetExportSessionDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WZMAssetExportSession : AVAssetExportSession

@property (nonatomic, weak) id<WZMAssetExportSessionDelegate> delegate;

- (void)startExport;

@end

@protocol WZMAssetExportSessionDelegate <NSObject>

@optional
- (void)assetExportSessionExporting:(WZMAssetExportSession *)exportSession;
- (void)assetExportSessionExportFail:(WZMAssetExportSession *)exportSession;
- (void)assetExportSessionExportSuccess:(WZMAssetExportSession *)exportSession;

@end

NS_ASSUME_NONNULL_END
