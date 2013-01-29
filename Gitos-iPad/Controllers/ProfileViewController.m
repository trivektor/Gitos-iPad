//
//  ProfileViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileViewController.h"
#import "SSKeychain.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "ProfileCell.h"
#import "RelativeDateDescriptor.h"
#import "AppConfig.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize user, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.user = nil;
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

- (void)performHouseKeepingTasks
{
    [scrollView setContentSize:self.view.frame.size];
    [self adjustFrameHeight];
    self.navigationItem.title = @"Profile";
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
    NSString *accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    
    NSURL *userUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user", [AppConfig getConfigValue:@"GithubApiHost"]]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:userUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   accessToken, @"access_token",
                                   @"bearer", @"token_type",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:userUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         self.user = [[User alloc] initWithOptions:json];
         [self displayUsernameAndAvatar];
         [profileTable reloadData];
         
         [self.spinnerView removeFromSuperview];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [profileTable dequeueReusableCellWithIdentifier:@"ProfileCell"];
    
    if (!cell) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileCell"];
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
            [mailViewController setToRecipients:[NSArray arrayWithObject:self.user.email]];
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
    } else if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.blog]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayUsernameAndAvatar
{
    NSData *avatarData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.user.avatarUrl]];
    
    avatar.image = [UIImage imageWithData:avatarData];
    avatar.layer.cornerRadius = 5.0;
    avatar.layer.masksToBounds = YES;
    
    if (self.user.name == (id)[NSNull null]) {
        nameLabel.text = self.user.login;
        loginLabel.hidden = YES;
    } else {
        nameLabel.text  = self.user.name;
        loginLabel.text = self.user.login;
    }
}

@end
