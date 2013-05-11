//
//  RepoLanguagesViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/11/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoLanguagesViewController.h"

@interface RepoLanguagesViewController ()

@end

@implementation RepoLanguagesViewController

@synthesize repo, languages, languagesTable;

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
    [self performHouseKeepingTasks];
    [self registerEvents];
    [repo fetchLanguages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Languages";
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayLanguages:)
                                                 name:@"RepoLanguagesFetched"
                                               object:nil];
}

- (void)fetchLanguages
{
    [repo fetchLanguages];
}

- (void)displayLanguages:(NSNotification *)notification
{
    languages = (NSMutableDictionary *)notification.object;
    [languagesTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return languages.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [languagesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    NSString *key = [[languages allKeys] objectAtIndex:indexPath.row];
    float percentage = [[[languages allValues] objectAtIndex:indexPath.row] floatValue] / 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.02f %%)", key, percentage];
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];

    return cell;
}

@end
