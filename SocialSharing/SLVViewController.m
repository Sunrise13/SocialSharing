//
//  SLVViewController.m
//  SocialSharing
//
//  Created by Oleksiy on 8/19/14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVViewController.h"
#import "SLVBubblesController.h"


@interface SLVViewController ()

@end

@implementation SLVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Share"]) {
        SLVBubblesController * dController = segue.destinationViewController;
        dController.mainController = self;
    }
}

@end
