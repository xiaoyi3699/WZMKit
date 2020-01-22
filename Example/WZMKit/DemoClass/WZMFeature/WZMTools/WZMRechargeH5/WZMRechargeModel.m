//
//  WZMRechargeModel.m
//  ZiMuKing
//
//  Created by Zhaomeng Wang on 2020/1/13.
//  Copyright © 2020 Vincent. All rights reserved.
//

#import "WZMRechargeModel.h"

@implementation WZMRechargeModel

+ (instancetype)shareModel {
    static WZMRechargeModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WZMRechargeModel alloc] init];
        model.wxSchemes = @"weixin://wap/pay";
        model.wxRedirect = @"&redirect_url=";
        model.wxAuthDomain = @"xiaoyiyun.com://";
        model.wxH5Identifier = @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?";
        
        model.alSchemes = @"alipay://";
        model.alSchemesKey = @"fromAppUrlScheme";
        model.alUrlKey = @"safepay";
    });
    return model;
}

@end
