//
//  WZMNewsDataProvider.m
//  APPIcon
//
//  Created by WangZhaomeng on 2017/8/19.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMNewsDataProvider.h"
#import "WZMJSONParse.h"

@implementation WZMNewsDataProvider {
    NSString *_fileName;
}

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _fileName = fileName;
        _currentList = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)loadData:(doHandler)loadHandler callBack:(doHandler)backHandler {
    
    self.httpRequestMethod = WZMHttpRequestMethodGet;
    
    self.requestUrl = [NSString stringWithFormat:@"http://www.vasueyun.cn/apro/%@",_fileName];
    [super loadData:loadHandler callBack:backHandler];
}

- (void)parseJSON:(id)json {
    [super parseJSON:json];
    NSArray *results = [WZMJSONParse getArrayValueInDict:json withKey:@"urls"];
    self.title       = [WZMJSONParse getStringValueInDict:json withKey:@"title"];
    
    for (NSDictionary *dic in results) {
        WZMNewsModel *model = [WZMNewsModel new];
        model.ID    = [WZMJSONParse getStringValueInDict:dic withKey:@"id"];
        model.title = [WZMJSONParse getStringValueInDict:dic withKey:@"title"];
        model.url   = [WZMJSONParse getStringValueInDict:dic withKey:@"url"];
        [_currentList addObject:model];
    }
}

- (void)clearMemoryData
{
    [super clearMemoryData];
    [_currentList removeAllObjects];
}

- (BOOL)isDataEmpty
{
    return _currentList.count == 0;
}

@end
