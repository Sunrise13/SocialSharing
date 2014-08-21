//
//  SLVUser.h
//  SocialSharing
//
//  Created by Sasha Gypsy on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLVUser : NSObject
@property (nonatomic,strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) UIImage* imageURL;

- (id) initWithServerResponse: (NSDictionary*) responseObject;
@end
