//
//  SLVVkToken.h
//  SocialSharing
//
//  Created by Sasha Gypsy on 20.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLVVkToken : NSObject
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;
@end
