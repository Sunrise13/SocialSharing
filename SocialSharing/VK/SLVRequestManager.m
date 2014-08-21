//
//  SLVRequestManager.m
//  SocialSharing
//
//  Created by Sasha Gypsy on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVRequestManager.h"
#import "AFNetworking.h"
#import "SLVVkToken.h"
#import "SLVVkViewController.h"

@interface SLVRequestManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;


@end

@implementation SLVRequestManager

+ (SLVRequestManager*) sharedManager
{
    static SLVRequestManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SLVRequestManager alloc] init];
        
    });
    return manager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        NSURL* url = [[NSURL alloc] initWithString: @"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) authorizeUser:(void (^)(SLVUser *user))completion
{
    SLVVkViewController* loginVC=[[SLVVkViewController alloc] initWithBlock:^(SLVVkToken * token){
        self.accessToken = token;
        if (completion)
        {
            completion (nil);
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows]firstObject] rootViewController];
    [mainVC presentViewController: nav
                         animated:YES
                       completion:nil];
}

@end
