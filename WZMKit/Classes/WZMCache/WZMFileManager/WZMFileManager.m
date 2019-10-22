//
//  WZMFileManager.m
//  test
//
//  Created by wangzhaomeng on 16/8/23.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMFileManager.h"
#import "WZMLogPrinter.h"
#import "WZMEnum.h"

#define WZM_FILE_MANAGER    [NSFileManager defaultManager]
#define WZM_USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
@implementation WZMFileManager

+ (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath]) {
        return YES;
    }
    WZMLog(@"fileExistsAtPath:文件未找到");
    return NO;
}

+ (BOOL)fileExistsAtPath:(NSString *)filePath isDirectory:(BOOL *)result{
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath isDirectory:result]) {
        return YES;
    }
    WZMLog(@"fileExistsAtPath:isDirectory:文件未找到");
    return NO;;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [WZM_FILE_MANAGER fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists) {
        if (isDirectory) {
            return YES;
        }
        else{
            NSError *error = nil;
            BOOL result = [WZM_FILE_MANAGER createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
            if (error) {
                WZMLog(@"创建文件夹失败:%@",error);
            }
            return result;
        }
    }
    else{
        NSError *error = nil;
        BOOL result = [WZM_FILE_MANAGER createDirectoryAtPath:path
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
        if (error) {
            WZMLog(@"创建文件夹失败:%@",error);
        }
        return result;
    }
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath]){
        return [WZM_FILE_MANAGER removeItemAtPath:filePath error:error];
    }
    WZMLog(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

+ (void)deleteFileInPath:(NSString *)filePath ofExtension:(NSString *)extension completion:(void(^)(NSArray<NSError *> *errors))completion{
    BOOL isDirectory = NO;
    NSMutableArray *errors = [[NSMutableArray alloc] initWithCapacity:0];
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSArray *subFilePaths = [WZM_FILE_MANAGER subpathsAtPath:filePath];
                for (NSString *subFilePath in subFilePaths) {
                    NSError *error = nil;
                    NSString *path = [filePath stringByAppendingPathComponent:subFilePath];
                    if ([path.pathExtension isEqualToString:extension]) {
                        [WZM_FILE_MANAGER removeItemAtPath:path error:&error];
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
            NSError *error = [NSError errorWithDomain:@"llwangzhaomeng" code:WZMIsNotDirectory userInfo:userInfo];
            [errors addObject:error];
            if (completion) {
                completion(errors);
            }
        }
    }
    else{
        NSString *errorMessage = [NSString stringWithFormat:@"\"%@\",is not found",filePath];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"llwangzhaomeng" code:WZMNotFound userInfo:userInfo];
        [errors addObject:error];
        if (completion) {
            completion(errors);
        }
    }
}

+ (void)deleteFileInPath:(NSString *)filePath completion:(doBlock)completion{
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [WZM_FILE_MANAGER removeItemAtPath:filePath error:nil];
            [WZM_FILE_MANAGER createDirectoryAtPath:filePath
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

+ (BOOL)moveItemAtURL:(NSURL *)atURO toURL:(NSURL *)toURL {
    return [WZM_FILE_MANAGER moveItemAtURL:atURO toURL:toURL error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)atPath toPath:(NSString *)toPath {
    return [WZM_FILE_MANAGER moveItemAtPath:atPath toPath:toPath error:nil];
}

+ (CGFloat)cacheSizeAtPath:(NSString *)path {
    float totalSize = 0;
    BOOL isDirectory = NO;
    if ([WZM_FILE_MANAGER fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory) {
            NSDirectoryEnumerator *fileEnumerator = [WZM_FILE_MANAGER enumeratorAtPath:path];
            for (NSString *fileName in fileEnumerator){
                NSString *filePath = [path stringByAppendingPathComponent:fileName];
                NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                unsigned long long length = [attrs fileSize];
                totalSize += length;
            }
        }
        else{
            totalSize = [[WZM_FILE_MANAGER attributesOfItemAtPath:path error:nil] fileSize];;
        }
        
    }
    return totalSize;
}

+ (NSMutableArray *)getFileNamesAtPath:(NSString *)filePath {
    NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:0];
    BOOL isDirectory = NO;
    if ([WZM_FILE_MANAGER fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (isDirectory) {
            NSDirectoryEnumerator *fileEnumerator = [WZM_FILE_MANAGER enumeratorAtPath:filePath];
            for (NSString *fileName in fileEnumerator){
                [fileNames addObject:fileName];
            }
        }
    }
    return fileNames;
}

+ (BOOL)setObj:(id)obj forKey:(NSString *)key{
    if (obj && key) {
        [WZM_USER_DEFAULTS setObject:obj forKey:key];
        return [WZM_USER_DEFAULTS synchronize];
    }
    WZMLog(@"数据存储到沙盒失败：key/obj不能为空");
    return NO;
}

+ (id)objForKey:(NSString *)key{
    if (key) {
        return [WZM_USER_DEFAULTS objectForKey:key];
    }
    WZMLog(@"从沙盒中取出数据失败：key不能为空");
    return nil;
}

+ (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    WZMLog(@"文件存储路径为:%@",path);
    return isOK;
}

+ (BOOL)removeObjForKey:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
    WZMLog(@"从沙盒中删除数据失败：key不能为空");
    return NO;
}

+ (void)removeAllObj {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    //方法二
//    NSDictionary * dic = [WZM_USER_DEFAULTS dictionaryRepresentation];
//    for (id key in dic)
//    {
//        [WZM_USER_DEFAULTS removeObjectForKey:key];
//    }
//    [WZM_USER_DEFAULTS synchronize];
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
        WZMLog(@"widget数据共享(存)失败：%@",error);
    }
    else {
        WZMLog(@"widget数据共享(存)成功：%@",obj);
    }
    return result;
}
#pragma mark

@end
