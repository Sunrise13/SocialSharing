//
//  SLVGoogleShare.h
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import "SLVBubblesController.h"

@interface SLVGoogleShare : NSObject <GPPSignInDelegate>

@property(assign, nonatomic) BOOL authorised;
@property(weak, nonatomic) SLVBubblesController * controller;
@property(weak, nonatomic) GPPSignIn*signIN;

- (IBAction) didTapShare;

@end
