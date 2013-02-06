//
//  ProfileViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileViewController.h"
#import "FollowViewController.h"
#import "WebsiteViewController.h"
#import "SSKeychain.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "ProfileCell.h"
#import "AppConfig.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize accessToken, user, spinnerView, avatar, profileTable, nameLabel, loginLabel, scrollView, hideBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.user = nil;
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.hideBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self prepareProfileTable];
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = self.hideBackButton;
}

- (void)performHouseKeepingTasks
{
    [scrollView setContentSize:self.view.frame.size];
    [self adjustFrameHeight];
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)prepareProfileTable
{
    UINib *nib = [UINib nibWithNibName:@"ProfileCell" bundle:nil];
    
    [profileTable registerNib:nib forCellReuseIdentifier:@"ProfileCell"];
    [profileTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [profileTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    [profileTable setBackgroundView:nil];
    [profileTable setScrollEnabled:NO];
}

// Adjust the frame size of UIScrollView
// http://stackoverflow.com/questions/2944294/how-i-auto-size-a-uiscrollview-to-fit-the-content
- (void)adjustFrameHeight
{
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight + 35))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo
{
    NSURL *userUrl;
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];

    if (self.user == nil) {
        userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user", githubApiHost]];
    } else {
        userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@", githubApiHost, [self.user getLogin]]];
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         self.user = [[User alloc] initWithData:json];
         self.navigationItem.title = [self.user getLogin];
         [self displayUsernameAndAvatar];
         [profileTable reloadData];
         
         [self.spinnerView setHidden:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.spinnerView setHidden:YES];
     }];
    
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProfileCell";

    ProfileCell *cell = [profileTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell displayByIndexPath:indexPath forUser:self.user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        // Popup the mail composer when clicking on email
        // http://stackoverflow.com/questions/9024994/open-mail-and-safari-from-uitableviewcell
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Hello"];
            [mailViewController setToRecipients:[NSArray arrayWithObject:[self.user getEmail]]];
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
    } else if (indexPath.row == 1) {
        WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
        websiteController.requestedUrl = [self.user getWebsite];
        [self.navigationController pushViewController:websiteController animated:NO];
    } else if (indexPath.row == 3) {
        FollowViewController *followController = [[FollowViewController alloc] init];
        followController.usersUrl = [self.user getFollowersUrl];
        followController.controllerTitle = @"Followers";
        [self.navigationController pushViewController:followController animated:YES];
    } else if (indexPath.row == 4) {
        FollowViewController *followController = [[FollowViewController alloc] init];
        followController.usersUrl = [self.user getFollowingUrl];
        followController.controllerTitle = @"Following";
        [self.navigationController pushViewController:followController animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayUsernameAndAvatar
{
    NSData *avatarData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.user getAvatarUrl]]];
    
    avatar.image = [UIImage imageWithData:avatarData];
    avatar.layer.cornerRadius = 5.0;
    avatar.layer.masksToBounds = YES;
    
    if ([self.user getName] == (id)[NSNull null]) {
        nameLabel.text = [self.user getLogin];
        loginLabel.hidden = YES;
    } else {
        nameLabel.text  = [self.user getName];
        loginLabel.text = [self.user getLogin];
    }
}

@end
