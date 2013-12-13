//
//  JobsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "JobsViewController.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

@synthesize jobs, jobsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        jobs = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHousekeepingTasks];
    [self registerEvents];
    [Job fetchAll];
}

- (void)performHousekeepingTasks
{
    [super performHousekeepingTasks];
    self.navigationItem.title = @"Jobs";
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayJobs:)
                                                 name:@"JobsFetched"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return jobs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [jobsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    Job *job = [jobs objectAtIndex:indexPath.row];

    cell.textLabel.text = [job getTitle];
    cell.detailTextLabel.text = [job getLocation];

    return cell;
}

- (void)displayJobs:(NSNotification *)notification
{
    [jobs addObjectsFromArray:notification.object];
    [jobsTable reloadData];
}

@end
