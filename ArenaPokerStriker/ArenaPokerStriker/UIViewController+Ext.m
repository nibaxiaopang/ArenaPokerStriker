//
//  UIViewController+Ext.m
//  ArenaPokerStriker
//
//  Created by jin fu on 2024/10/2.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

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
