//
//  LLFileManager.m
//  test
//
//  Created by wangzhaomeng on 16/8/23.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLFileManager.h"
#import "LLLog.h"
#import "LLEnum.h"

#define LL_FILE_MANAGER    [NSFileManager defaultManager]
#define LL_USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
@implementation LLFileManager

+ (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath]) {
        return YES;
    }
    ll_log(@"fileExistsAtPath:文件未找到");
    return NO;
}

+ (BOOL)fileExistsAtPath:(NSString *)filePath isDirectory:(BOOL *)result{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath isDirectory:result]) {
        return YES;
    }
    ll_log(@"fileExistsAtPath:isDirectory:文件未找到");
    return NO;;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [LL_FILE_MANAGER fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists) {
        if (isDirectory) {
            return YES;
        }
        else{
            NSError *error = nil;
            BOOL result = [LL_FILE_MANAGER createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
            if (error) {
                ll_log(@"创建文件夹失败:%@",error);
            }
            return result;
        }
    }
    else{
        NSError *error = nil;
        BOOL result = [LL_FILE_MANAGER createDirectoryAtPath:path
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
        if (error) {
            ll_log(@"创建文件夹失败:%@",error);
        }
        return result;
    }
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath]){
        return [LL_FILE_MANAGER removeItemAtPath:filePath error:error];
    }
    ll_log(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

+ (void)deleteFileInPath:(NSString *)filePath ofExtension:(NSString *)extension completion:(void(^)(NSArray<NSError *> *errors))completion{
    BOOL isDirectory = NO;
    NSMutableArray *errors = [[NSMutableArray alloc] initWithCapacity:0];
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSArray *subFilePaths = [LL_FILE_MANAGER subpathsAtPath:filePath];
                for (NSString *subFilePath in subFilePaths) {
                    NSError *error = nil;
                    NSString *path = [filePath stringByAppendingPathComponent:subFilePath];
                    if ([path.pathExtension isEqualToString:extension]) {
                        [LL_FILE_MANAGER removeItemAtPath:path error:&error];
                        if (error) {
                            [errors addObject:error];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(errors);
                    }
                });
            });
        }
        else{
            NSString *errorMessage = [NSString stringWithFormat:@"\"%@\",is not a directory",filePath];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"llwangzhaomeng" code:LLIsNotDirectory userInfo:userInfo];
            [errors addObject:error];
            if (completion) {
                completion(errors);
            }
        }
    }
    else{
        NSString *errorMessage = [NSString stringWithFormat:@"\"%@\",is not found",filePath];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"llwangzhaomeng" code:LLNotFound userInfo:userInfo];
        [errors addObject:error];
        if (completion) {
            completion(errors);
        }
    }
}

+ (void)deleteFileInPath:(NSString *)filePath completion:(doBlock)completion{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LL_FILE_MANAGER removeItemAtPath:filePath error:nil];
            [LL_FILE_MANAGER createDirectoryAtPath:filePath
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        });
    }
    else {
        if (completion) {
            completion();
        }
    }
}

+ (float)cacheSizeAtPath:(NSString *)cachePath{
    float totalSize = 0;
    BOOL isDirectory = NO;
    if ([LL_FILE_MANAGER fileExistsAtPath:cachePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            NSDirectoryEnumerator *fileEnumerator = [LL_FILE_MANAGER enumeratorAtPath:cachePath];
            for (NSString *fileName in fileEnumerator){
                NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
                NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                unsigned long long length = [attrs fileSize];
                totalSize += length/1024.0/1024.0;
            }
        }
        else{
            totalSize = [[LL_FILE_MANAGER attributesOfItemAtPath:cachePath error:nil] fileSize];;
        }
        
    }
    return totalSize;
}

+ (NSMutableArray *)getFileNamesAtPath:(NSString *)filePath {
    NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:0];
    BOOL isDirectory = NO;
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            NSDirectoryEnumerator *fileEnumerator = [LL_FILE_MANAGER enumeratorAtPath:filePath];
            for (NSString *fileName in fileEnumerator){
                [fileNames addObject:fileName];
            }
        }
    }
    return fileNames;
}

+ (BOOL)setObj:(id)obj forKey:(NSString *)key{
    if (obj && key) {
        [LL_USER_DEFAULTS setObject:obj forKey:key];
        return [LL_USER_DEFAULTS synchronize];
    }
    ll_log(@"数据存储到沙盒失败：key/obj不能为空");
    return NO;
}

+ (id)objForKey:(NSString *)key{
    if (key) {
        return [LL_USER_DEFAULTS objectForKey:key];
    }
    ll_log(@"从沙盒中取出数据失败：key不能为空");
    return nil;
}

+ (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    ll_log(@"文件存储路径为:%@",path);
    return isOK;
}

+ (BOOL)removeObjForKey:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
    ll_log(@"从沙盒中删除数据失败：key不能为空");
    return NO;
}

+ (void)removeAllObj {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    //方法二
//    NSDictionary * dic = [LL_USER_DEFAULTS dictionaryRepresentation];
//    for (id key in dic)
//    {
//        [LL_USER_DEFAULTS removeObjectForKey:key];
//    }
//    [LL_USER_DEFAULTS synchronize];
}

#pragma mark - widget数据共享
+ (id)widget_ObjForKey:(NSString *)key groupid:(NSString *)groupid{//读(UserDefaults)
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupid];
    return [shared valueForKey:key];
}

+ (BOOL)widget_SetObj:(id)obj forKey:(NSString *)key groupid:(NSString *)groupid{//存(UserDefaults)
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupid];
    [shared setObject:obj forKey:key];
    return [shared synchronize];
}

+ (NSString *)widget_ObjForFileName:(NSString *)fileName groupid:(NSString *)groupid{//读(沙盒)
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupid];
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/widget_%@",fileName]];
    NSString *value = [NSString stringWithContentsOfURL:containerURL
                                               encoding:NSUTF8StringEncoding
                                                  error:&err];
    return value;
}

+ (BOOL)widget_SetObj:(id)obj forFileName:(NSString *)fileName groupid:(NSString *)groupid{//存(沙盒)
    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupid];
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/widget_%@",fileName]];
    NSError *error = nil;
    BOOL result = [obj writeToURL:containerURL
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:&error];
    if (error) {
        ll_log(@"widget数据共享(存)失败：%@",error);
    }
    else {
        ll_log(@"widget数据共享(存)成功：%@",obj);
    }
    return result;
}
#pragma mark

@end
