//
//  SLVBubblesController.h
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVViewController.h"
#import <Social/Social.h>

@class SLVLInShareViewController;
@class SLVGoogleShare;
@class SLVTwitterShare;
@class SLVFaceBookShare;


@interface SLVBubblesController : UIViewController

///////////////////////////////////////////////////////////////
///GOOGLE +                                                ////
@property(strong, nonatomic) SLVGoogleShare * GoogleShar;  ////
///                                                        ////
///TWITTER ^                                               ////
@property(strong, nonatomic) SLVTwitterShare *twitterShare;////
///                                                        ////
///FaceBook f                                              ////
@property(strong,nonatomic)SLVFaceBookShare *facebookShare;////
///////////////////////////////////////////////////////////////
@property (nonatomic) SLVLInShareViewController * linkedIn;
//SLViewController
@property(strong, nonatomic) UIViewController * mainController;

@end
