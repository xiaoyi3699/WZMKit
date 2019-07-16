#import <Foundation/Foundation.h>

@interface NSData (WZMBase64)

+ (NSData *)wzm_dataWithBase64EncodedString:(NSString *)string;
- (NSString *)wzm_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)wzm_base64EncodedString;

@end

@interface NSString (WZMBase64)

+ (NSString *)wzm_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)wzm_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)wzm_base64EncodedString;
- (NSString *)wzm_base64DecodedString;
- (NSData *)wzm_base64DecodedData;

@end
