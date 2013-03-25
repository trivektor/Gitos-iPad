//
//  CommitsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitsViewController.h"
#import "CommitViewController.h"
#import "CommitCell.h"

@interface CommitsViewController ()

@end

@implementation CommitsViewController

static NSInteger PER_PAGE = 100;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.commits = [[NSMutableArray alloc] initWithCapacity:0];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerNib];
    [self fetchCommits];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Commits";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = LOADING_MESSAGE;
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"CommitCell" bundle:nil];
    [self.commitsTable registerNib:nib forCellReuseIdentifier:@"CommitCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commits count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommitCell";

    CommitCell *cell = [self.commitsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[CommitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.commit = [self.commits objectAtIndex:indexPath.row];
    [cell render];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitViewController *commitController = [[CommitViewController alloc] init];
    commitController.commit = [self.commits objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:commitController animated:YES];
}

- (void)fetchCommits
{
    NSURL *commitsUrl = [NSURL URLWithString:[self.repo getCommitsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commitsUrl];

    NSString *sha;
    NSInteger *startIndex;

    if (self.endSha == (id)[NSNull null] || self.endSha == nil) {
        sha = [self.branch getSha];
        startIndex = 0;
    } else {
        sha = self.endSha;
        startIndex = 1;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   sha, @"sha",
                                   [NSString stringWithFormat:@"%i", PER_PAGE], @"per_page",
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:commitsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         for (int i=startIndex; i < json.count; i++) {
             [self.commits addObject:[[Commit alloc] initWithData:[json objectAtIndex:i]]];
         }

         Commit *lastCommit = [self.commits lastObject];
         self.endSha = [lastCommit getSha];

         [self.commitsTable reloadData];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];

    [operation start];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        [self.hud show:YES];
        [self fetchCommits];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
