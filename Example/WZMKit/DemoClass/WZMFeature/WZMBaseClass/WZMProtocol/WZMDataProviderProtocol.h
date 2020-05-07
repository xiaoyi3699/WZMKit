//
//  WZMDataProviderProtocol.h
//  LLFoundation
//
//  Created by zhaomengWang on 17/2/27.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WZM_START_PAGE 1
typedef void(^doHandler)(void);

@protocol WZMDataProviderProtocol <NSObject>

@required
/**
 *  不带请求参数的数据请求方法，参数取默认值，或者是已经外部指定好的
 *
 *  @param loadHandler  请求开始前需要执行的动作，可以放空
 *  @param backHandler 请求结束后需要执行的动作，可以放空
 */
- (void)loadData:(doHandler)loadHandler
        callBack:(doHandler)backHandler;;

/**
 *  解析服务端返回的字符串数据
 *
 *  @param json JSON对象
 */
- (void)parseJSON:(id)json;

/**
 *  清空已有数据，有下拉刷新功能的页面需要用到
 */
- (void)clearMemoryData;

/**
 *  下拉刷新
 */
- (void)refreshData;

/**
 *  标记当前DataProvider是否是空的，默认是空
 */
- (BOOL)isDataEmpty;

@end
