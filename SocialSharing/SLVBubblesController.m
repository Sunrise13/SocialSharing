//
//  SLVBubblesController.m
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVBubblesController.h"
#import "AAShareBubbles.h"
#import "SLVGoogleShare.h"

@interface SLVBubblesController() <AAShareBubblesDelegate>
{
    
}
@end


@implementation SLVBubblesController

-(void)viewDidLoad
{
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center
                                                              radius:300
                                                              inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 45; // Default is 40
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showMailBubble = YES;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = YES;
    shareBubbles.showVkBubble = YES;
    shareBubbles.showInstagramBubble = YES;
    [shareBubbles show];

    //Guys it's special for GOOGLE+ :)
   if(!_GoogleShar)
   {
       _GoogleShar = [[SLVGoogleShare alloc] init];
       _GoogleShar.controller = self;
   }
    
   if([_GoogleShar authorised])[_GoogleShar.signIN trySilentAuthentication];
    ///////////////////////////////

}


-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            NSLog(@"Facebook");
            break;
        case AAShareBubbleTypeTwitter:
            NSLog(@"Twitter");
            break;
        case AAShareBubbleTypeMail:
            NSLog(@"Email");
            break;
        case AAShareBubbleTypeGooglePlus:
            [_GoogleShar didTapShare];
            break;
        case AAShareBubbleTypeTumblr:
            NSLog(@"Tumblr");
            break;
        case AAShareBubbleTypeVk:
            NSLog(@"Vkontakte (vk.com)");
            break;
        default:
            break;
    }
}

-(void)aaShareBubblesDidHide {
    NSLog(@"All Bubbles hidden");
}



@end
