//
//  LLSendEmail.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2018/2/8.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLSendEmail.h"
#import "LLLog.h"
#import "NSString+LLAddPart.h"

@implementation LLSendEmail

- (void)send {
    if ([MFMailComposeViewController canSendMail]) {
        NSMutableString *mailUrl = [[NSMutableString alloc] init];
        [mailUrl appendFormat:@"mailto:%@?", self.recipients];
        [mailUrl appendFormat:@"&subject=%@",self.subject];
        [mailUrl appendFormat:@"&body=%@",self.body];
        
        NSURL *URL = [NSURL URLWithString:mailUrl];
        if (URL == nil) {
            URL = [NSURL URLWithString:[mailUrl ll_getURLEncoded]];
        }
        [[UIApplication sharedApplication]openURL:URL];
    }
}

@end

@implementation UIViewController (LLSendEmail)

- (void)sendEmail:(LLSendEmail *)email {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose setSubject:email.subject];
        [mailCompose setToRecipients:[email.recipients componentsSeparatedByString:@","]];
        //非HTML格式
        [mailCompose setMessageBody:email.body isHTML:NO];
        //HTML格式
        //[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
        [self presentViewController:mailCompose animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled: {
            ll_log(@"用户取消编辑");
        }
            break;
        case MFMailComposeResultSaved: {
            ll_log(@"用户保存邮件");
        }
            break;
        case MFMailComposeResultSent: {
            ll_log(@"用户点击发送");
        }
            break;
        case MFMailComposeResultFailed: {
            ll_log(@"用户尝试保存或发送邮件失败: %@", [error localizedDescription]);
        }break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
