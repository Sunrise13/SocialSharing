//
//  SLVLinkedInViewController.h
//  Social Networks
//
//  Created by Ostap R on 18.08.14.
//  Copyright (c) 2014 SoftServe Lv-120. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLVLinkedInApi;
@class SLVViewController;

@interface SLVLInShareViewController : UIViewController

@property (nonatomic) SLVViewController *controllerWithData;
@property (nonatomic) SLVLinkedInApi * api;
@property (nonatomic) UIWebView *webView;
@end
