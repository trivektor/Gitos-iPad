//
//  GistViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistViewController.h"
#import "GistDetailsCell.h"
#import "GistFile.h"
#import "GistRawFileViewController.h"
#import "GistCommentsViewController.h"
#import "WebsiteViewController.h"

@interface GistViewController ()

@end

@implementation GistViewController

@synthesize gist, hud, detailsTable, filesTable, files, actionOptions, isStarring;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        files = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:[gist getName]];
    [self performHouseKeepingTasks];
    [self registerNib];
    [self registerEvents];
    [self getGistStats];
    [gist checkStar];
}

- (void)performHouseKeepingTasks
{
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"GistDetailsCell" bundle:nil];
    
    NSArray *tables = [[NSArray alloc] initWithObjects:detailsTable, filesTable, nil];
    
    UITableView *table;
    
    for (int i=0; i < tables.count; i++) {
        table = [tables objectAtIndex:i];
        [table registerNib:nib forCellReuseIdentifier:@"GistDetailsCell"];
        [table setBackgroundColor:[UIColor clearColor]];
        [table drawSeparator];
        [table setScrollEnabled:NO];
        [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    }
}

- (void)registerEvents
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(displayGistStats:)
                   name:@"GistStatsFetched"
                 object:nil];

    [center addObserver:self
               selector:@selector(prepareActionOptionsForStatus:)
                   name:@"GistStarringChecked"
                 object:nil];

    [center addObserver:self
               selector:@selector(updateStarredStatus)
                   name:@"GistStarringUpdated"
                 object:nil];
}

- (void)getGistStats
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
    [gist fetchStats];
}

- (void)displayGistStats:(NSNotification *)notification
{
    files = [NSMutableArray arrayWithArray:[gist getGistFiles]];
    [filesTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == detailsTable) {
        return 3;
    } else {
        return [files count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == detailsTable) {
        return [self cellForDetailsTableAtIndexPath:indexPath];
    } else {
        return [self cellForBranchesTableAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GistDetailsCell";

    GistDetailsCell *cell = [detailsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[GistDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setGist:gist];
    [cell renderForIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [filesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    GistFile *file = [files objectAtIndex:indexPath.row];
    cell.textLabel.text  = [file getName];
    cell.textLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    [cell defineAccessoryType];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == filesTable) {
        GistRawFileViewController *gistRawFileController = [[GistRawFileViewController alloc] init];
        gistRawFileController.gistFile = [files objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:gistRawFileController
                                             animated:YES];
    } else if (tableView == detailsTable) {
        if (indexPath.row == 2) {
            GistCommentsViewController *gistCommentsController = [[GistCommentsViewController alloc] init];
            gistCommentsController.gist = gist;
            [self.navigationController pushViewController:gistCommentsController
                                                 animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareActionOptionsForStatus:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *) notification.object;
    int statusCode = [operation.response statusCode];
    NSString *starOption;

    if (statusCode == 204) {
        isStarring = YES;
        starOption = @"Unstar";
    } else {
        isStarring = NO;
        starOption = @"Star";
    }

    actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                delegate:self
                                       cancelButtonTitle:@""
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:starOption, @"Fork", @"View on Github", @"Tweet This Gist", nil];

    UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-share"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showAvailableActions)];
    [actionsButton setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:23]
    } forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = actionsButton;
}

- (void)showAvailableActions
{
    [actionOptions showInView:self.view];
}

- (void)updateStarredStatus
{
    NSString *starOption = nil;

    isStarring = !isStarring;

    if (isStarring) {
        starOption = @"Unstar";
        [AppHelper flashAlert:@"Gist starred" inView:self.view];
    } else {
        starOption = @"Star";
        [AppHelper flashAlert:@"Gist unstarred" inView:self.view];
    }

    actionOptions = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                delegate:self
                                       cancelButtonTitle:@""
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:starOption, @"View on Github", @"Tweet This Gist", nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    User *currentUser = [CurrentUserManager getUser];

    if (buttonIndex == 0) {
        if (isStarring) {
            // Unstar a gist
            [currentUser unstarGist:gist];
        } else {
            // Star a gist
            [currentUser starGist:gist];
        }
    } else if ([[actionOptions buttonTitleAtIndex:buttonIndex] isEqualToString:@"View on Github"]) {
        WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
        websiteController.requestedUrl = [gist getHtmlUrl];
        [self.navigationController pushViewController:websiteController animated:YES];
    } else if ([[actionOptions buttonTitleAtIndex:buttonIndex] isEqualToString:@"Tweet This Gist"]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[gist getHtmlUrl]];
        [tweetSheet addImage:[UIImage imageNamed:@"twitter-logo"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

@end
