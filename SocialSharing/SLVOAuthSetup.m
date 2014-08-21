//
//  SLVOAuthSetup.m
//  SocialSharing
//
//  Created by Ostap R on 19.08.14.
//  Copyright (c) 2014 SoftServe LV-120. All rights reserved.
//

#import "SLVOAuthSetup.h"
#import "SLVDBManager.h"
#import "Users.h"
static  NSString * kLinkedInApiKey=@"772ojbop21zpbj";
static  NSString * kLinkedInSecretKey=@"SEFTnXX310DnJtE6";



@interface SLVOAuthSetup() <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation SLVOAuthSetup

-(instancetype)init
{
    self=[super init];
    //_controller=controller;
//    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Users"];
//    NSPredicate *pred=[NSPredicate predicateWithFormat:@"serviceType==[c]\"LinkedIn\""]; //serviceType
//    [request setPredicate:pred];
//    NSArray *service=[[[SLVDBManager sharedManager] context] executeFetchRequest:request error:nil];
//    if([service count]==0)
//    {
//        [self setupLinkedIn];
//        //[self getUser];
//    }

    return self;
    
}
-(void)viewDidLoad
{
    
    NSLog(@"OAuth loaded");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"OAuth disapper");
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"OAuth appear");
}

-(void)setupLinkedIn
{
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:self animated:YES completion:nil];
    
    if(self.webView==nil)
        NSLog(@"NIIIIILLLL");
    CGRect web=CGRectMake(self.controller.view.bounds.origin.x, self.controller.view.bounds.origin.y+150, self.controller.view.bounds.size.width+700, self.controller.view.bounds.size.height+700);
    self.webView=[[UIWebView alloc] initWithFrame:web];
    self.webView.delegate=self;
    NSLog(@"%@",self.webView.delegate);
    self.webView.scalesPageToFit=YES;
    [self.view addSubview:self.webView];
    NSLog(@"%@ thistiti",self.navigationController);
    //[self presentViewController:self animated:YES completion:nil];
   // [self.navigationController pushViewController:self animated:YES];
   
    
    //NSLog(@"%@",navigation);
    //[navigation pushViewController:self animated:YES];
    
    NSMutableString *path=[[NSMutableString alloc] initWithString:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id="];
    [path appendString:kLinkedInApiKey];
    [path appendString:@"&state="];
    
    NSDate *data=[NSDate date];
    NSTimeInterval interval=[data timeIntervalSince1970];
    NSNumber *intervalObj=[NSNumber numberWithDouble:interval];
    [path appendString:[intervalObj stringValue]];
    
    [path appendString:@"&redirect_uri=http://example.com"];
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [self.webView loadRequest:request];

}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url=request.URL.absoluteString;
    
    
    if([url rangeOfString:@"http://example.com"].location!=NSNotFound)
    {
        NSInteger loc=[url rangeOfString:@"code="].location;
        if(loc!=NSNotFound)
        {
            NSString * tempToken=[self getTempTokenFromString:url];
            [self getToken:tempToken];
            return NO;
        }
        
    }
    
    return YES;
}

#pragma mark - LinkedInAuthorization

-(NSString *)getTempTokenFromString:(NSString *)path
{
    NSInteger loc=[path rangeOfString:@"code="].location;
    if(loc!=NSNotFound)
    {
        NSInteger loc2=[path rangeOfString:@"&state="].location;
        NSRange range=NSMakeRange(loc+5, loc2-loc-5);
        NSString *temp_token=[path substringWithRange:range];
        NSLog(@"%@", temp_token);
        return temp_token;
    }
    return @"NO TEMP TOKEN";
    
}

-(NSString *)getToken:(NSString *)tempToken
{
    NSMutableString * path=[[NSMutableString alloc] initWithString:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code="];
    [path appendString:tempToken];
    [path appendString:@"&redirect_uri=http://example.com"];
    [path appendString:@"&client_id="];
    [path appendString:kLinkedInApiKey];
    [path appendString:@"&client_secret="];
    [path appendString:kLinkedInSecretKey];
    NSLog(@"%@", path);
    NSURL * url=[NSURL URLWithString:path];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    

    
    //[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    [NSURLConnection sendAsynchronousRequest:request
                                      queue:[NSOperationQueue mainQueue]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSString * accessToken=dic[@"access_token"];
         Users * user=[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[[SLVDBManager sharedManager] context]];
         user.serviceType=@"LinkedIn";
         user.token=accessToken;
         [self.delegate userData:user];
         [self.webView removeFromSuperview];
         [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];

     }
     ];



    
    return [url absoluteString];
    
}

-(void)getUser
{
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Users"];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"serviceType==[c]\"LinkedIn\""]; //serviceType
    [request setPredicate:pred];
    NSArray *service=[[[SLVDBManager sharedManager] context] executeFetchRequest:request error:nil];
    if([service count]==0)
    {
        NSLog(@"No data");
        [self setupLinkedIn];

    }
    else
    {
        [self.delegate userData:service[0]];
    }

 
}



@end




