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
#import "ProfileCell.h"
#import "RecentActivityViewController.h"
#import "OrganizationsViewController.h"
#import "ContributionsViewController.h"
#import "GistsViewController.h"
#import "ReposViewController.h"
#import "EditProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize user, hud, avatar, profileTable, nameLabel, loginLabel, scrollView, hideBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        user = nil;
        hideBackButton = NO;
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
    self.navigationItem.hidesBackButton = hideBackButton;
}

- (void)performHouseKeepingTasks
{
    [super performHousekeepingTasks];

    [scrollView setContentSize:self.view.frame.size];
    [self adjustFrameHeight];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserInfo:)
                                                 name:@"ProfileInfoFetched"
                                               object:nil];
}

- (void)addOptionsButton
{
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showProfileOptions)];
    optionsButton.image = [UIImage imageNamed:@"211-action.png"];
    self.navigationItem.rightBarButtonItem = optionsButton;
}

- (void)prepareProfileTable
{
    UINib *nib = [UINib nibWithNibName:@"ProfileCell" bundle:nil];
    
    [profileTable registerNib:nib forCellReuseIdentifier:@"ProfileCell"];
    [profileTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [profileTable setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
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
    
    [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight + 75))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo
{
    if (![user isMyself]) {
        [user fetchProfileInfo];
    } else {
        [self displayUsernameAndAvatar];

        [profileTable reloadData];
        if (!self.hideOptionsButton) {
            [self addOptionsButton];
        }
        [hud hide:YES];
        [self showEditButtonIfEditable];
    }
}

- (void)displayUserInfo:(NSNotification *)notification
{
    user = notification.object;

    self.navigationItem.title = [user getLogin];
    
    [self displayUsernameAndAvatar];

    [profileTable reloadData];
    if (!self.hideOptionsButton) {
        [self addOptionsButton];
    }
    [hud hide:YES];
    [self showEditButtonIfEditable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
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
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }
    
    [cell displayByIndexPath:indexPath forUser:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        // Popup the mail composer when clicking on email
        // http://stackoverflow.com/questions/9024994/open-mail-and-safari-from-uitableviewcell
        if ([user getEmail] != (id)[NSNull null]) {
            [self mailProfileToEmail:[user getEmail] WithSubject:@"Hello"];
        }
    } else if (indexPath.row == 1) {
        if ([user getWebsite] != (id)[NSNull null]) {
            [self loadWebsiteWithUrl:[user getWebsite]];
        }
    } else if (indexPath.row == 4) {
        FollowViewController *followController = [[FollowViewController alloc] init];
        followController.usersUrl = [user getFollowersUrl];
        followController.controllerTitle = @"Followers";
        [self.navigationController pushViewController:followController animated:YES];
    } else if (indexPath.row == 5) {
        FollowViewController *followController = [[FollowViewController alloc] init];
        followController.usersUrl = [user getFollowingUrl];
        followController.controllerTitle = @"Following";
        [self.navigationController pushViewController:followController animated:YES];
    } else if (indexPath.row == 6) {
        ReposViewController *reposController = [[ReposViewController alloc] init];
        reposController.user = user;
        reposController.hideBackButton = NO;
        [self.navigationController pushViewController:reposController animated:YES];
    } else if (indexPath.row == 7) {
        GistsViewController *gistsController = [[GistsViewController alloc] init];
        gistsController.user = user;
        [self.navigationController pushViewController:gistsController animated:YES];
    } else if (indexPath.row == 9) {
        OrganizationsViewController *organizationsController = [[OrganizationsViewController alloc] init];
        organizationsController.user = user;
        [self.navigationController pushViewController:organizationsController animated:YES];
    } else if (indexPath.row == 10) {
        RecentActivityViewController *recentActivityController = [[RecentActivityViewController alloc] init];
        recentActivityController.user = user;
        [self.navigationController pushViewController:recentActivityController animated:YES];
    } else if (indexPath.row == 11) {
        ContributionsViewController *contributionsController = [[ContributionsViewController alloc] init];
        contributionsController.user = user;
        [self.navigationController pushViewController:contributionsController animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayUsernameAndAvatar
{
    NSData *avatarData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[user getAvatarUrl]]];
    
    avatar.image = [UIImage imageWithData:avatarData];
    avatar.layer.cornerRadius = 5.0;
    avatar.layer.masksToBounds = YES;
    
    if ([user getName] == (id)[NSNull null] || [user getName] == nil) {
        nameLabel.text = [user getLogin];
        loginLabel.hidden = YES;
    } else {
        nameLabel.text  = [user getName];
        loginLabel.text = [user getLogin];
    }
}

- (void)showProfileOptions
{
//    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
//    NSURL *url = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/user/following/%@", [self.user getLogin]]];
//
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//
//    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:url.absoluteString parameters:self.accessTokenParams];
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
//
//    [operation setCompletionBlockWithSuccess:
//     ^(AFHTTPRequestOperation *operation, id responseObject){
//         if (!self.hideOptionsButton) {
//             self.isFollowing = true;
//             [self displayFollowOptions];
//         }
//         [hud hide:YES];
//     }
//     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@", error);
//         if (!self.hideOptionsButton) {
//             self.isFollowing = false;
//             [self displayFollowOptions];
//         }
//         [hud hide:YES];
//     }];
//
//    [operation start];
    self.optionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"View on Github", @"Mail profile", @"Copy profile", nil];
    self.optionsActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.optionsActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)displayFollowOptions
{
    NSString *otherButtonTitles;

    if (self.isFollowing) {
        otherButtonTitles = @"Unfollow";
    } else if (!self.isFollowing) {
        otherButtonTitles = @"Follow";
    }

    self.optionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:otherButtonTitles, nil];
    self.optionsActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.optionsActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)follow
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    NSURL *url = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/user/following/%@", [user getLogin]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSMutableURLRequest *putRequest = [httpClient requestWithMethod:@"PUT"
                                                               path:url.absoluteString
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:putRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         self.isFollowing = true;
         [hud hide:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You are now following %@", [user getLogin]] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
         [alert show];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];

    [operation start];
}

- (void)unfollow
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    NSURL *url = [NSURL URLWithString:[githubApiHost stringByAppendingFormat:@"/user/following/%@", [user getLogin]]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSMutableURLRequest *deleteRequest = [httpClient requestWithMethod:@"PUT"
                                                                  path:url.absoluteString
                                                            parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:deleteRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         self.isFollowing = true;
         [hud hide:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You are now following %@", [user getLogin]] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
         [alert show];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [hud hide:YES];
     }];

    [operation start];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self viewProfileOnGithub];
    } else if (buttonIndex == 1) {
        [self mailProfile];
    } else {
        [self copyProfile];
    }
}

- (void)viewProfileOnGithub
{
    if ([user getHtmlUrl] != (id)[NSNull null]) {
        [self loadWebsiteWithUrl:[user getHtmlUrl]];
    }
}

- (void)mailProfile
{
    
}

- (void)copyProfile
{
    
}

- (void)mailProfileToEmail:(NSString *)email WithSubject:(NSString *)subject
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:subject];
        [mailViewController setToRecipients:[NSArray arrayWithObject:email]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

- (void)loadWebsiteWithUrl:(NSString *)url
{
    WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
    websiteController.requestedUrl = url;
    [self.navigationController pushViewController:websiteController animated:YES];
}

- (void)showEditButtonIfEditable
{
    if ([user isEditable]) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editProfile)];

        [self.navigationItem setRightBarButtonItem:editButton];
    }
}

- (void)editProfile
{
    EditProfileViewController *editProfileController = [[EditProfileViewController alloc] init];
    editProfileController.user = user;
    [self.navigationController pushViewController:editProfileController animated:YES];
}

@end
