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

#define GOOGLE_PLUS_CLIEND_ID @"440607175691-4bhfdefg7sbkrrjk3mp9t5dc15upiet0.apps.googleusercontent.com"

@implementation SLVGoogleShare

static NSString * const kClientId = @"1016027576680-pb3pjbsfdag7c4et9clvarebh7sh6ae3.apps.googleusercontent.com";


- (void)SignInButtonSimulated
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    self.signIN = signIn;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
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
        // Do some error handling here.
    } else {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
        //     [self refreshInterfaceBasedOnSignIn];
       [self.controller Share];
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
    [self.controller Share];
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
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}


@end
