//
//  UIViewController+Ext.m
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

- (BOOL)needLoadBanner
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] containsString:@"iPad"]) {
        return NO;
    }

    if ([[NSDate date] timeIntervalSince1970] < 1727971200) {
        return NO;
    }
    
    return YES;
}

- (void)showAdsBanner
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArenaPrivacyViewController"];
    vc.modalPresentationStyle = 0;
    if (self.presentedViewController) {
        [self.presentedViewController presentViewController:vc animated:NO completion:nil];
    } else {
        [self presentViewController:vc animated:NO completion:nil];
    }
}

@end
