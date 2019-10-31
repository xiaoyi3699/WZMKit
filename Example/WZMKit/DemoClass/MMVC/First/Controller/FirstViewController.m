//
//  FirstViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

/**********************************************************************************/
/*MVVM混合工厂模式、WZMNetWorking、WZMRefresh、WZMJSONParse
 
 MVVM是Model-View-ViewModel的简写,它本质上就是MVC的改进版。
 MVVM就是将其中的View的状态和行为抽象化,让我们将视图UI和业务逻辑分开。
 当然这些事ViewModel已经帮我们做了,它可以取出Model的数据,同时帮忙处理View中由于需要展示内容而涉及的业务逻辑。
 
 工厂模式可以借鉴抽象类来理解,基类实现一些基本的、公共的函数、协议,子类根据各自的业务需求在此基础上进行扩展。
 
 结合当前ViewController对工厂模式的介绍,这是一个基本的列表视图,包含上拉加载、下拉刷新:
 1、创建UITableView并实现上拉加载、下拉刷新,直接调用父类懒加载函数:_tableView = self.superTableView;
 2、加载数据,需要使用ViewModel层,创建ViewModel的子类,并在子类内部实现加载数据的相关函数,
 将ViewModel与当前ViewController关联,self.superDataProvider = _newDataProvider;
 3、工作原理:上拉加载、下拉刷新触发时,self.superDataProvider发起请求,
 由于self.superDataProvider = _newDataProvider,因此,该请求实际由_newDataProvider发起;
 数据处理完毕后self.superTableView刷新数据,
 由于_tableView = self.superTableView,因此,当前视图刷新。
 */
/**********************************************************************************/

#import "FirstViewController.h"
#import "WZMNewsDataProvider.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    WZMNewsDataProvider *_newDataProvider;
}

@end

@implementation FirstViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第一页";
        _newDataProvider = [[WZMNewsDataProvider alloc] initWithFileName:@"article.json"];
        self.superDataProvider = _newDataProvider;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = self.superTableView;
    _tableView.frame = WZMRectMiddleArea();
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView wzm_cleraExtraLine];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < _newDataProvider.currentList.count) {
        WZMNewsModel *model = _newDataProvider.currentList[indexPath.row];
        WZMWebViewController *webVC = [[WZMWebViewController alloc] initWithUrl:model.url];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newDataProvider.currentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    if (indexPath.row < _newDataProvider.currentList.count) {
        WZMNewsModel *model = _newDataProvider.currentList[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}

//基类的一些常用函数
//AES128位加密 base64编码 注：kCCKeySizeAES128点进去可以更换256位加密
-(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1];//
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        NSString *stringBase64 = [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
        return stringBase64;
        
    }
    free(buffer);
    return nil;
}

//解密
-(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];//base64解码
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
