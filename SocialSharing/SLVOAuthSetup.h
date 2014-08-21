//
//  SLVOAuthSetup.h
//  SocialSharing
//
//  Created by Ostap R on 19.08.14.
//  Copyright (c) 2014 SoftServe LV-120. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Users;

@protocol SLVOAuthSetupDelegate <NSObject>

@required
-(void)userData:(Users *)user;

@end

@class Users;

@interface SLVOAuthSetup : UIViewController <UIWebViewDelegate>

@property (nonatomic) UIViewController * controller;
@property (nonatomic) __block id<SLVOAuthSetupDelegate> delegate;
@property (nonatomic) UIViewController * webWeb;
-(void) getUser;


@end


/*//
//  SLVLinkedInViewController.m
//  Social Networks
//
//  Created by Ostap R on 15.08.14.
//  Copyright (c) 2014 SoftServe Lv-120. All rights reserved.
//

#import "SLVLTableViewController.h"
#import "SLVDBManager.h"
#import "Users.h"
#import "SLVLinkedInApi.h"
#import "SLVLinkedInProfileViewController.h"

static  NSString * kLinkedInApiKey=@"772ojbop21zpbj";
static  NSString * kLinkedInSecretKey=@"SEFTnXX310DnJtE6";
//static const NSString * kLinkedInOAuthUserToken=@"394c8fdb-d189-4c97-bb33-602dcb83cdcb"; //May be deprecated
//static const NSString * kLinkedInOAuthUserSecret=@"2ee1d5eb-2958-47c4-bcde-f31236974d3a"; //May be deprecated

@interface SLVLTableViewController () <UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

-(void)setupLinkedIn;
@property (nonatomic) NSMutableData * userToken;
@property (nonatomic) Users * regUser;
@property (nonatomic) SLVLinkedInApi *api;

@end

@implementation SLVLTableViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    {
        NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"Users"];
        NSPredicate *pred=[NSPredicate predicateWithFormat:@"serviceType==[c]\"LinkedIn\""]; //serviceType
        [request setPredicate:pred];
        NSArray *service=[[[SLVDBManager sharedManager] context] executeFetchRequest:request error:nil];
        if([service count]==0)
        {
            [self setupLinkedIn];
        }
        else
        {
            self.regUser=service[0];
            self.api=[[SLVLinkedInApi alloc] init];
            self.api.user=self.regUser;
        }
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupLinkedIn
{
    if(self.webView==nil)
        NSLog(@"NIIIIILLLL");
    CGRect web=CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+150, self.view.bounds.size.width, self.view.bounds.size.height);
    self.webView=[[UIWebView alloc] initWithFrame:web];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=YES;
    
    [self.view addSubview:self.webView];
    
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
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost"]]];
    
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

#pragma mark - NSURLConnectionDelegate //May be not used

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.userToken= [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    [self.userToken appendData:data];
    //[_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString * str=[[NSString alloc] initWithData:self.userToken encoding:NSStringEncodingConversionAllowLossy];
    NSLog(@"%@", str);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERRRRRROOOOR %@", error);
    // NSString *key=[[NSString alloc]initWithFormat:@"%p", connection ];
    // NSArray * arr=[self.dicOfData objectForKey:key];
    //void(^result)(NSData *, NSError *)=((void (^)(NSData *, NSError *))arr[1]);
    //[self.dicOfData removeObjectForKey:key];
    //[self.setOfConnections removeObject:connection];
    //result(nil, error);
    
    
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
    //Formatting data for POST request
    
    //    {
    //        "share": {
    //            "comment": "Check out the LinkedIn Share API!",
    //            "content": {
    //                "title": "LinkedIn Developers Documentation On Using the Share API",
    //                "description": "Leverage the Share API to maximize engagement on user-generated content on LinkedIn",
    //                "submitted-url": "https://developer.linkedin.com/documents/share-api",
    //                "submitted-image-url": "https://m3.licdn.com/media/p/3/000/124/1a6/089a29a.png"
    //            },
    //            "visibility": { "code": "anyone" }
    //        }
    //    }
    
    NSMutableDictionary * root=[[NSMutableDictionary alloc] init];
    NSMutableDictionary * share=[[NSMutableDictionary alloc] init];
    NSMutableDictionary * content=[[NSMutableDictionary alloc] init];
    NSMutableDictionary * visibility=[[NSMutableDictionary alloc] init];
    
    [root setObject:share forKey:@"share"];
    [root setObject:visibility forKey:@"visibility"];
    
    [share setObject:]
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSString * accessToken=dic[@"access_token"];
         Users * user=[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[[SLVDBManager sharedManager] context]];
         user.serviceType=@"LinkedIn";
         user.token=accessToken;
     }
     ];
    
    
    //https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code
    //    &code=AUTHORIZATION_CODE
    //    &redirect_uri=YOUR_REDIRECT_URI
    //    &client_id=YOUR_API_KEY
    //    &client_secret=YOUR_SECRET_KEY
    return url;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Profile"])
    {
        ((SLVLinkedInProfileViewController *)[segue destinationViewController]).api=self.api;
        
    }
}*/

