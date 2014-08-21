//
//  SLVLinkedInViewController.m
//  Social Networks
//
//  Created by Ostap R on 18.08.14.
//  Copyright (c) 2014 SoftServe Lv-120. All rights reserved.
//

#import "SLVLInShareViewController.h"
#import "SLVLinkedInApi.h"
#import "SLVBubblesController.h"

@interface SLVLInShareViewController () <SLVLinkedInApiDelegate>


@property (nonatomic) SLVBubblesController * bubblesController;


@end

@implementation SLVLInShareViewController

-(instancetype)init
{
    self=[super init];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share:) name:@"LinkedIn" object:nil];
    self.api=[[SLVLinkedInApi alloc] init];
    self.api.delegate=self;
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Share controller loaded");
    
    [super viewDidLoad];
    
    
   
	// Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"Share controller disappear");
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self share];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Share will appear");
    
   // SEL s = self.navigationController.navigationBar.backItem.leftBarButtonItem.action;
//    [self.navigationController.navigationBar.backItem.leftBarButtonItem.action ]
   // [self.navigationController.navigationBar.backItem.leftBarButtonItem performSelector:s withObject:nil afterDelay:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)share
{
    [self.api makeShare];
}

-(void)madeShare:(NSURL *)url
{

    NSLog(@"%@", self.navigationController);
    //[self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@", [[UIApplication sharedApplication] keyWindow].rootViewController);
    NSArray * conrolellers=self.navigationController.viewControllers;
    for (id temp in conrolellers) {
        NSLog(@"%@",temp);
        if([temp isKindOfClass:[SLVBubblesController class]])
        {
            NSLog(@"50/50");
            NSLog(@"%@",self.navigationController.topViewController);
        }
        
    }
    CGPoint webPoints=CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y+64);//self.navigationController.navigationBar.frame.origin.y);
    NSLog(@"%f",self.navigationController.navigationBar.frame.origin.y);
    CGSize webSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);//-self.navigationController.navigationBar.frame.size.height);
    CGRect webRect;
    webRect.origin=webPoints;
    webRect.size=webSize;
    self.webView=[[UIWebView alloc] initWithFrame:webRect];
    self.webView.clipsToBounds=YES;
    [self.navigationController.topViewController.view addSubview:self.webView];
    self.webView.scrollView.clipsToBounds = YES;
    //[self.view addSubview:self.webView];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

@end
