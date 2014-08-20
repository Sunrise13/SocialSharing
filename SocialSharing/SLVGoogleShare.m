//
//  SLVGoogleShare.m
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVGoogleShare.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "SLVBubblesController.h"

//#define GOOGLE_PLUS_CLIEND_ID @"440607175691-4bhfdefg7sbkrrjk3mp9t5dc15upiet0.apps.googleusercontent.com"
@interface SLVGoogleShare() <GPPShareDelegate>

@end
@implementation SLVGoogleShare

static NSString * const kClientId = @"1016027576680-pb3pjbsfdag7c4et9clvarebh7sh6ae3.apps.googleusercontent.com";


- (void)SignInButtonSimulated
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    self.signIN = signIn;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  
    signIn.clientID = kClientId;
    signIn.delegate = self;
    [signIn authenticate];
}

- (void)didReceiveMemoryWarning
{
    [self didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {

    } else {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
       
        [self Share];
         self.authorised = TRUE;
    }
}

// Share Code
- (IBAction) didTapShare {
    
    if(!self.authorised)
    {
        [self SignInButtonSimulated];
    }
    else
    [self Share];
}


// For Signout USe this code
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

// Disconnet User
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        NSLog(@"Ok");
    }
}

-(void)Share
{
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [GPPShare sharedInstance].delegate = self;
    [shareBuilder setPrefillText:((SLVViewController*)self.controller.mainController).shareText.text];
    [shareBuilder attachImage:((SLVViewController*)self.controller.mainController).shareImage.image];
    [shareBuilder open];
}

- (void)finishedSharing:(BOOL)shared;
{
   if(shared)
       [self.controller.mainController.navigationController popToRootViewControllerAnimated:YES];
}

@end
