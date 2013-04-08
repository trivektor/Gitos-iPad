//
//  RepoTreeViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeViewController.h"
#import "RawFileViewController.h"
#import "CommitsViewController.h"

@interface RepoTreeViewController ()

@end

@implementation RepoTreeViewController

@synthesize treeTable, treeNodes, repo, node, hud, branch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        treeNodes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [self fetchData];
}

- (void)performHouseKeepingTasks
{
    if (node == nil) {
        self.navigationItem.title = [branch getName];
    } else if ([node isTree]) {
        self.navigationItem.title = [node getPath];
    }

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc] initWithTitle:@"Commits"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(showCommitForBranch)];

    [treeTable registerNib:[UINib nibWithNibName:@"RepoTreeCell" bundle:nil] forCellReuseIdentifier:@"RepoTreeCell"];

    [self.navigationItem setRightBarButtonItem:commitButton];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayTree:)
                                                 name:@"TreeFetched"
                                               object:nil];
}

- (void)fetchData
{
    if (node == nil) {
        [repo fetchTopLayerForBranch:branch];
    } else if ([node isTree]) {
        [node fetchTree];
    }
}

- (void)fetchBlob
{
    RawFileViewController *rawFileController = [[RawFileViewController alloc] init];
    rawFileController.repo      = repo;
    rawFileController.branch    = branch;
    rawFileController.fileName  = [node getPath];
    [self.navigationController pushViewController:rawFileController animated:YES];
}


- (void)displayTree:(NSNotification *)notification
{
    treeNodes = [notification.userInfo valueForKey:@"Nodes"];
    [treeTable reloadData];
    [hud setHidden:YES];
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
    return [treeNodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RepoTreeCell";
    
    RepoTreeCell *cell = [treeTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[RepoTreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setNode:[treeNodes objectAtIndex:indexPath.row]];
    [cell render];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTreeNode *selectedNode = [treeNodes objectAtIndex:indexPath.row];
    
    if ([selectedNode isBlob]) {
        RawFileViewController *rawFileController = [[RawFileViewController alloc] init];

        rawFileController.repo      = repo;
        rawFileController.branch    = branch;
        rawFileController.fileName  = [selectedNode getPath];

        [self.navigationController pushViewController:rawFileController animated:YES];
    } else if ([selectedNode isTree]) {
        RepoTreeViewController *repoTreeController = [[RepoTreeViewController alloc] init];

        repoTreeController.branch   = branch;
        repoTreeController.repo     = repo;
        repoTreeController.node     = selectedNode;

        [self.navigationController pushViewController:repoTreeController animated:YES];
    }
}

- (void)showCommitForBranch
{
    CommitsViewController *commitsController = [[CommitsViewController alloc] init];
    commitsController.branch = branch;
    commitsController.repo   = repo;
    [self.navigationController pushViewController:commitsController animated:YES];
}

@end
