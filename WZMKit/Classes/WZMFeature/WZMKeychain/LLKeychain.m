//
//  LLKeychain.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/22.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLKeychain.h"

static NSString *const LLKeychainUtilsErrorDomain = @"LLKeychainUtilsErrorDomain";
@implementation LLKeychain

+ (NSString *)getPasswordForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error {
    if (!username || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return nil;
    }
    
    if (error != nil) {
        *error = nil;
    }
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    
    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *)kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *)kSecClassGenericPassword, username, serviceName, nil];
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).
    
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setValue: (id) kCFBooleanTrue forKey:(__bridge_transfer id) kSecReturnAttributes];
    CFTypeRef attrResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef) attributeQuery, &attrResult);
    //NSDictionary *attributeResult = (__bridge_transfer NSDictionary *)attrResult;
    
    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:status userInfo:nil];
        }
        
        return nil;
    }
    
    // We have an existing item, now query for the password data associated with it.
    
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setValue:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    CFTypeRef resData = NULL;
    status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)passwordQuery, (CFTypeRef *)&resData);
    NSData *resultData = (__bridge_transfer NSData *)resData;
    
    if (status != noErr) {
        if (status == errSecItemNotFound) {
            // We found attributes for the item previously, but no password now, so return a special error.
            // Users of this API will probably want to detect this error and prompt the user to
            // re-enter their credentials.  When you attempt to store the re-entered credentials
            // using storeUsername:andPassword:forServiceName:updateExisting:error
            // the old, incorrect entry will be deleted and a new one with a properly encrypted
            // password will be added.
            if (error != nil) {
                *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-1999 userInfo:nil];
            }
        }
        else {
            // Something else went wrong. Simply return the normal Keychain API error code.
            if (error != nil) {
                *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:status userInfo:nil];
            }
        }
        
        return nil;
    }
    
    NSString *password = nil;
    
    if (resultData) {
        password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    else {
        // There is an existing item, but we weren't able to get password data for it for some reason,
        // Possibly as a result of an item being incorrectly entered by the previous code.
        // Set the -1999 error so the code above us can prompt the user again.
        if (error != nil) {
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-1999 userInfo:nil];
        }
    }
    
    return password;
}

+ (BOOL)storeUsername:(NSString *)username andPassword:(NSString *)password forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError **)error
{
    if (!username || !password || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return NO;
    }
    
    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingPassword = [LLKeychain getPasswordForUsername:username andServiceName:serviceName error:&getError];
    
    if ([getError code] == -1999)
    {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.
        
        getError = nil;
        
        [self deleteItemForUsername:username andServiceName:serviceName error:&getError];
        
        if ([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
            return NO;
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    OSStatus status = noErr;
    
    if (existingPassword)
    {
        // We have an existing, properly entered item with a password.
        // Update the existing item.
        
        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            //Only update if we're allowed to update existing.  If not, simply do nothing.
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClass,
                             kSecAttrService,
                             kSecAttrLabel,
                             kSecAttrAccount,
                             nil];
            
            NSArray *objects = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClassGenericPassword,
                                serviceName,
                                serviceName,
                                username,
                                nil];
            
            NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            status = SecItemUpdate((__bridge_retained CFDictionaryRef)query, (__bridge_retained CFDictionaryRef)[NSDictionary dictionaryWithObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge_transfer NSString *)kSecValueData]);
        }
    }
    else
    {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClass,
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData,
                         nil];
        
        NSArray *objects = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClassGenericPassword,
                            serviceName,
                            serviceName,
                            username,
                            [password dataUsingEncoding:NSUTF8StringEncoding],
                            nil];
        
        NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        status = SecItemAdd((__bridge_retained CFDictionaryRef)query, NULL);
    }
    
    if (error != nil && status != noErr)
    {
        // Something went wrong with adding the new item. Return the Keychain error code.
        *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:status userInfo:nil];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteItemForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:(__bridge_transfer NSString *)kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];
    
    NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)query);
    
    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:status userInfo:nil];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)purgeItemsForServiceName:(NSString *)serviceName error:(NSError **)error {
    if (!serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return NO;
    }
    
    if (error != nil)
    {
        *error = nil;
    }
    
    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setValue:serviceName forKey:(__bridge id)kSecAttrService];
    
    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchData);
    
    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain:LLKeychainUtilsErrorDomain code:status userInfo:nil];
        
        return NO;
    }
    
    return YES;
}

@end
