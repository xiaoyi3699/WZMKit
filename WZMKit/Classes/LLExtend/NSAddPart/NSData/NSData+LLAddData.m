//
//  NSData+LLAddData.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/9/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSData+LLAddData.h"

@implementation NSData (LLAddData)

///16进制转NSData
+ (NSData *)ll_getDataByHex1:(NSString *)hex {
    if (!hex || [hex length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([hex length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hex length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hex substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (NSData *)ll_getDataByHex2:(NSString *)hex {
    const char *chars = [hex UTF8String];
    NSUInteger i = 0, len = hex.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

+ (NSData *)ll_getDataByObj:(id)obj{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSData *)ll_getDataByString:(NSString *)string{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (LLImageType)ll_contentType {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return LLImageTypeJPEG;
            
        case 0x89:
            return LLImageTypePNG;
            
        case 0x47:
            return LLImageTypeGIF;
            
        case 0x49:
        case 0x4D:
            return LLImageTypeTIFF;
            
        case 0x52:
            if ([self length] < 12) {
                return LLImageTypeUnknown;
            }
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"]
                && [testString hasSuffix:@"WEBP"])
            {
                return LLImageTypeWEBP;
            }
            return LLImageTypeUnknown;
    }
    return LLImageTypeUnknown;
}

@end

@implementation NSMutableData (LLAddData)


@end
