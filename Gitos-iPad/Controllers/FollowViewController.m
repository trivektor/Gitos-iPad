//
//  FollowViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FollowViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface FollowViewController ()

@end

@implementation FollowViewController

@synthesize controllerTitle, user, users, usersTable, accessToken, usersUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.users = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.controllerTitle;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
    [self fetchUsers:self.currentPage++];
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
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [usersTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    User *u = [self.users objectAtIndex:indexPath.row];

    [cell.imageView setImageWithURL:[NSURL URLWithString:[u getAvatarUrl]] placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [u getLogin];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    profileController.user = [self.users objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)fetchUsers:(NSInteger)page
{
    NSURL *fetchUrl = [NSURL URLWithString:self.usersUrl];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:fetchUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:fetchUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         for (int i=0; i < json.count; i++) {
             [self.users addObject:[[User alloc] initWithData:[json objectAtIndex:i]]];
         }
         [usersTable reloadData];
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
        // Bottom of UITableView reached
         [self.hud hide:NO];
        [self fetchUsers:self.currentPage++];
    }
}

@end
