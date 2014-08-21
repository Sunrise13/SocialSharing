//
//  SLVVkViewController.h
//  SocialSharing
//
//  Created by Sasha Gypsy on 19.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVBubblesController.h"
#import "SLVVkToken.h"
#import "SLVRequestManager.h"



typedef void(^LoginCompletionBlock)(SLVVkToken* token);

@interface SLVVkViewController : UIViewController

- (id) initWithBlock:(LoginCompletionBlock) completionBlock;

@property(assign, nonatomic) BOOL authorisedVk;
@property(weak, nonatomic) SLVBubblesController * bubbleController;
@property (weak, nonatomic) UIWebView * authView;
- (void) postToVk;

@end
