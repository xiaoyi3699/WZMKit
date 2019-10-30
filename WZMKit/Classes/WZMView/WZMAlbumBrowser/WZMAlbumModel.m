//
//  WZMAlbumModel.m
//  Pods-WZMKit_Example
//
//  Created by WangZhaomeng on 2019/10/30.
//

#import "WZMAlbumModel.h"

@implementation WZMAlbumModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.count = 0;
        self.selectedCount = 0;
        self.photos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
