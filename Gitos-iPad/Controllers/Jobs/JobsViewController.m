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
    [self registerNib];
    [self registerEvents];
    [Job fetchAll];
}

- (void)performHousekeepingTasks
{
    [super performHousekeepingTasks];
    self.navigationItem.title = @"Jobs";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"JobCell" bundle:nil];
    [jobsTable registerNib:nib forCellReuseIdentifier:@"JobCell"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"JobCell";

    JobCell *cell = [jobsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[JobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.job = [jobs objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)displayJobs:(NSNotification *)notification
{
    [jobs addObjectsFromArray:notification.object];
    [jobsTable reloadData];
}

@end
