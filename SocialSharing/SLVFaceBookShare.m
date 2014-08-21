//
//  SLVTwitterShare.m
//  SocialSharing
//
//  Created by iVasyl on 8/20/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVFaceBookShare.h"
#import "SLVBubblesController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation SLVFaceBookShare

//@synthesize account;

- (void) share {
    @try {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *slcontroller = [SLComposeViewController
                                                     composeViewControllerForServiceType:SLServiceTypeFacebook];
            if (![((SLVViewController*)self.controller.mainController).shareText.text  isEqual:@""]){
                [slcontroller setInitialText:((SLVViewController*)self.controller.mainController).shareText.text];
            }
            if ((((SLVViewController*)self.controller.mainController).shareImage.image.size.height>1) && (((SLVViewController*)self.controller.mainController).shareImage.image.size.height>1)){
            [slcontroller addImage:((SLVViewController*)self.controller.mainController).shareImage.image];
            }
            //[slcontroller addURL:[NSURL URLWithString:@"www.google.com.ua/"]];
            slcontroller.completionHandler = ^(SLComposeViewControllerResult result){
                NSLog(@"Completed");
            };
            [((SLVViewController*)self.controller.mainController) presentViewController:slcontroller animated:YES completion:nil];
        }else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error login account!"
                                                            message:@"Please setup user account!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cansel"
                                                  otherButtonTitles:@"Create new", nil];
            [alert show];
            NSLog(@"The twitter service is not available");
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exeption!");
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {}
    else if (buttonIndex == 1)
    {
        //[self setAlertForSettingPage];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
        NSURL *fr =[NSURL URLWithString:[@"https://www.facebook.com/" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://www.facebook.com/" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
    }
}

@end
