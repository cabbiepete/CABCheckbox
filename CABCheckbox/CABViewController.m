//
//  CABViewController.m
//  CABCheckbox
//
//  Created by Peter Simmons on 5/02/14.
//  Copyright (c) 2014 Simnix. All rights reserved.
//

#import "CABViewController.h"
#import "CABCheckbox.h"

@interface CABViewController ()

@property (nonatomic) CABCheckbox *checkbox;

@end

@implementation CABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.checkbox = [[CABCheckbox alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 44.0f, 44.0f)];
	[self.view addSubview:self.checkbox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
