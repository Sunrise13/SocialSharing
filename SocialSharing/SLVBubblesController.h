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

@class SLVGoogleShare;
@class SLVFaceBookShare;


@interface SLVBubblesController : UIViewController

///GOOGLE +
@property(strong, nonatomic) SLVGoogleShare * GoogleShar;
////////



///FaceBook
@property(strong,nonatomic)SLVFaceBookShare *facebookShare;
///

//SLViewController
@property(strong, nonatomic) UIViewController * mainController;

@end
