//
//  SLVLinkedInApi.h
//  Social Networks
//
//  Created by Ostap R on 18.08.14.
//  Copyright (c) 2014 SoftServe Lv-120. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVViewController.h"
#import "Users.h"
#import "SLVOAuthSetup.h"

@protocol SLVLinkedInApiDelegate <NSObject>

@optional
-(void)dataOfProfile:(NSDictionary *)data;
-(void)madeShare:(NSURL *)url;

@end

@interface SLVLinkedInApi : NSObject <SLVOAuthSetupDelegate>


@property(nonatomic) Users * user;
@property(nonatomic) id<SLVLinkedInApiDelegate> delegate;
@property(nonatomic) __block NSDictionary * response;
@property(nonatomic) SLVOAuthSetup *oauth;
-(NSDictionary *)getProfile;
-(void)makeShare;
@end
