//
//  GitosViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/20/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GitosViewController.h"

@interface GitosViewController ()

@end

@implementation GitosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)performHousekeepingTasks
{
    if (self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"399-list1.png"]
                                       landscapeImagePhone:nil
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(showMenu)];

        [self.navigationItem setLeftBarButtonItem:menuButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

@end
