//
//  RepoCodeSearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCodeSearchViewController.h"

@interface RepoCodeSearchViewController ()

@end

@implementation RepoCodeSearchViewController

@synthesize repo, searchBar, resultsTable;

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.title = [NSString stringWithFormat:@"Search within %@", [repo getName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
