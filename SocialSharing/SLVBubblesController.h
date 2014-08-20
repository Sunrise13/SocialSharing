//
//  SLVBubblesController.h
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVViewController.h"
@class SLVGoogleShare;


@interface SLVBubblesController : UIViewController

///GOOGLE +
@property(strong, nonatomic) SLVGoogleShare * GoogleShar;
////////


//SLViewController
@property(strong, nonatomic) UIViewController * mainController;

@end
