//
//  RTViewController.m
//  InteractivePush
//
//  Created by Ricky Tan on 01/19/2017.
//  Copyright (c) 2017 Ricky Tan. All rights reserved.
//

@import RTInteractivePush;
#import "RTViewController.h"

@interface RTViewController ()

@end

@implementation RTViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationController.rt_enableInteractivePush = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Comments"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onComments:)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"press Comments on the top right, or\nswipe from right edge to left to\nview comments";
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 4;
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.frame = self.view.bounds;
    [self.view addSubview:label];
}

- (void)onComments:(id)sender
{
    [self.navigationController pushViewController:[[UITableViewController alloc] initWithStyle:UITableViewStylePlain]
                                         animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable __kindof UIViewController *)rt_nextSiblingController
{
    return [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
}

@end
