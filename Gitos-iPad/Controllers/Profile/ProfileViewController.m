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

@synthesize user, hud, avatar, profileTable, nameLabel, loginLabel, scrollView, isFollowing, optionsActionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        user = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [self prepareProfileTable];
    [self getUserInfo];

    if (!user.isMyself) {
        [[CurrentUserManager getUser] checkFollowing:user];
    }
}

- (void)performHouseKeepingTasks
{
    if ([user isMyself]) {
        [super performHousekeepingTasks];
    }

    [self adjustFrameHeight];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)registerEvents
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(displayUserInfo:)
                   name:@"ProfileInfoFetched"
                 object:nil];

    [center addObserver:self
               selector:@selector(prepareProfileOptions:)
                   name:@"UserFollowingChecked"
                 object:nil];

    [center addObserver:self
               selector:@selector(respondToFollowingEvents:)
                   name:@"UserFollowingEvent"
                 object:nil];
}

- (void)addOptionsButton
{
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-share"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showProfileOptions)];
    [optionsButton setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontAwesomeFamilyName size:23]
    } forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = optionsButton;
}

- (void)prepareProfileTable
{
    UINib *nib = [UINib nibWithNibName:@"ProfileCell" bundle:nil];

    [profileTable registerNib:nib forCellReuseIdentifier:@"ProfileCell"];
    [profileTable setScrollEnabled:NO];
    [profileTable setBackgroundColor:[UIColor clearColor]];
    [profileTable drawSeparator];
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

    [scrollView setContentSize:(CGSizeMake(self.view.frame.size.width, scrollViewHeight + 80))];
    [scrollView setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo
{
    [user fetchProfileInfo];
}

- (void)displayUserInfo:(NSNotification *)notification
{
    user = notification.object;

    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Profile", [user getLogin]];
    
    [self displayUsernameAndAvatar];

    [profileTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
    [self showEditButtonIfEditable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
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

        FollowViewController *followController = [FollowViewController new];
        followController.user = user;
        followController.userType = @"followers";
        followController.controllerTitle = @"Followers";
        [self.navigationController pushViewController:followController animated:YES];

    } else if (indexPath.row == 5) {

        FollowViewController *followController = [FollowViewController new];
        followController.user = user;
        followController.userType = @"following";
        followController.controllerTitle = @"Following";
        [self.navigationController pushViewController:followController animated:YES];

    } else if (indexPath.row == 6) {

        ReposViewController *reposController = [ReposViewController new];
        reposController.user = user;
        [self.navigationController pushViewController:reposController animated:YES];

    } else if (indexPath.row == 7) {

        GistsViewController *gistsController = [GistsViewController new];
        gistsController.user = user;
        [self.navigationController pushViewController:gistsController animated:YES];

    } else if (indexPath.row == 9) {

        OrganizationsViewController *organizationsController = [OrganizationsViewController new];
        organizationsController.user = user;
        [self.navigationController pushViewController:organizationsController animated:YES];

    } else if (indexPath.row == 10) {

        RecentActivityViewController *recentActivityController = [RecentActivityViewController new];
        recentActivityController.user = user;
        [self.navigationController pushViewController:recentActivityController animated:YES];

    } else if (indexPath.row == 11) {

        ContributionsViewController *contributionsController = [ContributionsViewController new];
        contributionsController.user = user;
        [self.navigationController pushViewController:contributionsController animated:YES];

    } else if (indexPath.row == 12) {

        WebsiteViewController *websiteController = [WebsiteViewController new];
        websiteController.requestedUrl = [NSString stringWithFormat:@"%@/%@", [AppConfig getConfigValue:@"ReportCardHost"], [user getLogin]];
        [self.navigationController pushViewController:websiteController animated:YES];

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
    
    if ([user getName] == (id)[NSNull null] || [user getName] == nil) {
        nameLabel.text = [user getLogin];
        loginLabel.hidden = YES;
    } else {
        nameLabel.text  = [user getName];
        loginLabel.text = [user getLogin];
    }
}

- (void)prepareProfileOptions:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)notification.object;

    NSInteger statusCode = [operation.response statusCode];

    if (statusCode == 204) {
        isFollowing = YES;
    } else if (statusCode == 404) {
        isFollowing = NO;
    }

    NSString *otherButtonTitles = isFollowing ? @"Unfollow" : @"Follow";

    optionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:otherButtonTitles, @"View on Github", nil];
    optionsActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

    [self addOptionsButton];
}

- (void)showProfileOptions
{
    [optionsActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        User *currentUser = [CurrentUserManager getUser];

        if (isFollowing) {
            [currentUser unfollowUser:user];
        } else {
            [currentUser followUser:user];
        }
    } else if (buttonIndex == 1) {
        [self loadWebsiteWithUrl:[user getHtmlUrl]];
    }
}

- (void)viewProfileOnGithub
{
    if ([user getHtmlUrl] != (id)[NSNull null]) {
        [self loadWebsiteWithUrl:[user getHtmlUrl]];
    }
}

- (void)mailProfileToEmail:(NSString *)email WithSubject:(NSString *)subject
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:subject];
        [mailViewController setToRecipients:[NSArray arrayWithObject:email]];

        [self presentViewController:mailViewController
                           animated:YES
                         completion:nil];
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
    if (user.isMyself) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-edit"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(editProfile)];

        [editButton setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:23]
        } forState:UIControlStateNormal];

        [self.navigationItem setRightBarButtonItem:editButton];
    }
}

- (void)editProfile
{
    EditProfileViewController *editProfileController = [[EditProfileViewController alloc] init];
    editProfileController.user = user;
    [self.navigationController pushViewController:editProfileController animated:YES];
}

- (void)respondToFollowingEvents:(NSNotification *)notification
{
    isFollowing = !isFollowing;

    NSString *followOption;

    if (isFollowing) {
        followOption = @"Unfollow";
        [AppHelper flashAlert:@"User followed" inView:self.view];
    } else {
        followOption = @"Follow";
        [AppHelper flashAlert:@"User unfollowed" inView:self.view];
    }

    optionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions"
                                                delegate:self
                                       cancelButtonTitle:@""
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:followOption, @"View on Github", nil];
}

@end
