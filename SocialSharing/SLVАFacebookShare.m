//
//  SLVАFacebookShare.m
//  SocialSharing
//
//  Created by Сергей on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVАFacebookShare.h"

@implementation SLVFacebookShare





- (void) share
{
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *slComposeViewController;
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageWithData:((SLVViewController *)self.controller.mainController).shareImage]];
        [slComposeViewController setInitialText:((SLVViewController *)self.controller.mainController).shareText];
        
        slComposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Complete!");
        };
        
        [((SLVViewController*)self.controller.mainController) presentViewController:slComposeViewController animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Account Found!"
                                                        message:@"Configure Facebook account in settings"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        alert .alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
    }
}

@end
