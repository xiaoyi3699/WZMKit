//
//  WZMAlbumModel.h
//  Pods-WZMKit_Example
//
//  Created by WangZhaomeng on 2019/10/30.
//

#import <Foundation/Foundation.h>

@interface WZMAlbumModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger selectedCount;

@end
