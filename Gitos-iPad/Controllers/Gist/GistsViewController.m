//
//  GistsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistsViewController.h"
#import "GistCell.h"
#import "GistViewController.h"
#import "NewGistViewController.h"

@interface GistsViewController ()

@end

@implementation GistsViewController

@synthesize currentPage, hud, user, gistsTable, gists;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        gists = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performHousekeepingTasks];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Gists";

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading";

    [self registerNib];
    [self registerEvents];

    [self setupPullToRefresh];
    [user fetchGistsForPage:currentPage++];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.hideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHousekeepingTasks
{
    [super performHousekeepingTasks];

    UIBarButtonItem *newGistButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-plus"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(createNewGist)];

    [newGistButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:newGistButton];
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"GistCell" bundle:nil];
    [gistsTable registerNib:nib forCellReuseIdentifier:@"GistCell"];
    [gistsTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [gistsTable setBackgroundView:nil];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserGists:)
                                                 name:@"UserGistsFetched"
                                               object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gists count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GistCell *cell = [gistsTable dequeueReusableCellWithIdentifier:@"GistCell"];
    
    if (!cell) {
        cell = [[GistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GistCell"];
    }
    
    cell.gist = [gists objectAtIndex:indexPath.row];
    [cell render];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GistViewController *gistController = [[GistViewController alloc] init];
    gistController.gist = [gists objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:gistController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [hud show:YES];
        [user fetchGistsForPage:currentPage++];
    }
}

- (void)displayUserGists:(NSNotification *)notification
{
    [gists addObjectsFromArray:notification.object];
    [gistsTable reloadData];
    [gistsTable.pullToRefreshView stopAnimating];
    [hud hide:YES];
}

- (void)setupPullToRefresh
{
    [hud show:YES];
    currentPage = 1;
    [gistsTable addPullToRefreshWithActionHandler:^{
        [user fetchGistsForPage:currentPage++];
    }];
}

- (void)createNewGist
{
    NewGistViewController *newGistController = [[NewGistViewController alloc] init];
    [self.navigationController pushViewController:newGistController animated:YES];
}

@end
