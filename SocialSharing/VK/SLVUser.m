//
//  SLVUser.m
//  SocialSharing
//
//  Created by Sasha Gypsy on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVUser.h"

@implementation SLVUser

- (id) initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super init];
    if (self)
    {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        if (urlString)
        {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

@end
