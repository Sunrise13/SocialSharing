//
//  SLVTwitterShare.h
//  SocialSharing
//
//  Created by iVasyl on 8/20/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVBubblesController.h"
#import <Accounts/Accounts.h>

@interface SLVFaceBookShare : NSObject

//@property ACAccountStore *account;
@property(weak, nonatomic) SLVBubblesController * controller;
- (void) share;

@end
