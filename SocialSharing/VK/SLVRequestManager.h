//
//  SLVRequestManager.h
//  SocialSharing
//
//  Created by Sasha Gypsy on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVUser.h"
#import "SLVVkToken.h"

@interface SLVRequestManager : NSObject
@property (strong, nonatomic, readonly) SLVUser* currentUser;
@property (strong, nonatomic) SLVVkToken* accessToken;

+ (SLVRequestManager*) sharedManager;

- (void) authorizeUser: (void(^) (SLVUser* user)) completion;

@end
