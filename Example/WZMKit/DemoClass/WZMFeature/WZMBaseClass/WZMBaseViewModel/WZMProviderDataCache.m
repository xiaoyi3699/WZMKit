//
//  WZMProviderDataCache.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/5/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import "WZMProviderDataCache.h"
#import "WZMMacro.h"
#import "WZMBase64.h"

@implementation WZMProviderDataCache {
    NSString *_cachePath;
    NSMutableDictionary *_memoryCache;
}

+ (instancetype)dataCache {
    static WZMProviderDataCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[WZMProviderDataCache alloc] init];
    });
    return imageCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cachePath = [WZM_CACHE_PATH stringByAppendingPathComponent:@"LLDataCache"];
        _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self createDirectoryAtPath:_cachePath];
    }
    return self;
}

- (NSString *)storeData:(id)data forKey:(NSString *)key {
    if (data == nil || key.length == 0) {
        NSLog(@"键值不能为空");
        return @"";
    }
    NSString *tureKey = [key wzm_base64EncodedString];
    //存到内存
    [_memoryCache setValue:data forKey:tureKey];
    //存到本地
    NSString *cachePath = [_cachePath stringByAppendingPathComponent:tureKey];
    if ([self writeFile:data toPath:cachePath]) {
        return cachePath;
    }
    return @"";
}

- (id)dataForKey:(NSString *)key {
    NSString *tureKey = [key wzm_base64EncodedString];
    id responseObject = [_memoryCache objectForKey:tureKey];
    if (responseObject == nil) {
        NSString *cachePath = [_cachePath stringByAppendingPathComponent:tureKey];
        if ([self fileExistsAtPath:cachePath]) {
            NSData *data = [NSData dataWithContentsOfFile:cachePath];
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //存到内存
            [_memoryCache setValue:responseObject forKey:key];
        }
    }
    return responseObject;
}

- (NSString *)filePathForKey:(NSString *)key {
    NSString *tureKey = [key wzm_base64EncodedString];
    return [_cachePath stringByAppendingPathComponent:tureKey];
}

- (void)clearMemory {
    [_memoryCache removeAllObjects];
}

- (void)clearImageCacheCompletion:(doBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearMemory];
        if ([self deleteFileAtPath:_cachePath error:nil]) {
            [self createDirectoryAtPath:_cachePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

#pragma mark - 文件管理
- (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    NSLog(@"fileExistsAtPath:文件未找到");
    return NO;
}

- (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists && isDirectory) {
        return YES;
    }
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    if (error) {
        NSLog(@"创建文件夹失败:%@",error);
    }
    return result;
}

- (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    NSLog(@"文件存储路径为:%@",path);
    return isOK;
}

- (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
    }
    NSLog(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

@end
