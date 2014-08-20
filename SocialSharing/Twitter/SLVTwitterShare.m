//
//  SLVTwitterShare.m
//  SocialSharing
//
//  Created by iVasyl on 8/20/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVTwitterShare.h"
#import "SLVBubblesController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation SLVTwitterShare

- (IBAction) didTapShare {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *slcontroller = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //((SLVViewController*)self.controller.mainController).shareText.text = @"Do you want to have a kitten?";
        //((SLVViewController*)self.controller.mainController).shareImage.image =[UIImage imageNamed:@"mejn-kun_3.jpg"];

        if (((SLVViewController*)self.controller.mainController).shareText.text != nil){
            [slcontroller setInitialText:((SLVViewController*)self.controller.mainController).shareText.text];}

        if ((((SLVViewController*)self.controller.mainController).shareImage.image.size.height>1) && (((SLVViewController*)self.controller.mainController).shareImage.image.size.height>1)){
            [slcontroller addImage:((SLVViewController*)self.controller.mainController).shareImage.image];
        }
        //[slcontroller addURL:[NSURL URLWithString:@"www.google.com.ua/"]];
        slcontroller.completionHandler = ^(SLComposeViewControllerResult result){
            NSLog(@"Completed");
        };
        [((SLVViewController*)self.controller.mainController) presentViewController:slcontroller animated:YES completion:nil];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error login account!"
                                                        message:@"Please setup user account!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cansel"
                                              otherButtonTitles:@"Create new", nil];
        [alert show];
        NSLog(@"The twitter service is not available");
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://www.facebook.com/" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];

    }
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

@end
