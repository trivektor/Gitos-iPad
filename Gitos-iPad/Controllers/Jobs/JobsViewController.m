//
//  JobsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "JobsViewController.h"
#import "WebsiteViewController.h"
#import "Job.h"
#import "MZFormSheetController.h"
#import "JobSearchViewController.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

@synthesize jobs, jobsTable, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        jobs = [NSMutableArray arrayWithCapacity:0];
        currentPage = 1;
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
    [Job fetchJobsForPage:currentPage++];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
}

- (void)performHousekeepingTasks
{
    [super performHousekeepingTasks];
    self.navigationItem.title = @"Jobs";

    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-search"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                    action:@selector(searchJobs)];

    [searchBtn setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontAwesomeFamilyName size:20]
    } forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:searchBtn];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Job *job = [jobs objectAtIndex:indexPath.row];
    WebsiteViewController *websiteController = [WebsiteViewController new];
    websiteController.requestedUrl = [job getUrl];
    [self.navigationController pushViewController:websiteController
                                         animated:YES];
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
    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
    [jobs addObjectsFromArray:notification.object];
    [jobsTable reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
        [Job fetchJobsForPage:currentPage++];
    }
}

- (void)searchJobs
{
    UIViewController *vc = [JobSearchViewController new];

    [self presentFormSheetWithViewController:vc
                                    animated:YES
                           completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

@end
