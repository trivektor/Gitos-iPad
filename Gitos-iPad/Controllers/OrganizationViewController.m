//
//  OrganizationViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "OrganizationViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "WebsiteViewController.h"

@interface OrganizationViewController ()

@end

@implementation OrganizationViewController

@synthesize organization, organizationTable, accessToken, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchOrganizationInfo];
}

- (void)performHouseKeepingTasks
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
    [organizationTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [organizationTable setBackgroundView:nil];
    [organizationTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [organizationTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
}

- (void)fetchOrganizationInfo
{
    NSURL *organizationUrl = [NSURL URLWithString:[self.organization getUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:organizationUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:organizationUrl.absoluteString parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         self.organization = [[Organization alloc] initWithData:json];
         self.navigationItem.title = [self.organization getName];
         [organizationTable reloadData];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];
    
    [operation start];
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

    NSString *textLabel = @"", *textDetail = @"";
    
    switch (indexPath.row) {
        case 0:
            textLabel = @"Name";
            textDetail = [self.organization getName];
            break;
        case 1:
            textLabel = @"Location";
            textDetail = [self.organization getLocation];
            break;
        case 2:
            textLabel = @"Created";
            textDetail = [self.organization getCreatedAt];
            break;
        case 3:
            textLabel = @"Last updated";
            textDetail = [self.organization getUpdatedAt];
            break;
        case 4:
            textLabel = @"Website";
            textDetail = [self.organization getWebsite];
            break;
        case 5:
            textLabel = @"Followers";
            textDetail = [NSString stringWithFormat:@"%i", [self.organization getNumberOfFollowers]];
            break;
        case 6:
            textLabel = @"Following";
            textDetail = [NSString stringWithFormat:@"%i", [self.organization getNumberOfFollowing]];
            break;
        default:
            break;
    }

    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
    cell.textLabel.text = textLabel;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:14];
    cell.detailTextLabel.text = textDetail;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        NSString *url = [self.organization getWebsite];

        if (url != nil) {
            WebsiteViewController *websiteController = [[WebsiteViewController alloc] init];
            websiteController.requestedUrl = url;
            [self.navigationController pushViewController:websiteController animated:YES];
        }
    }
}

@end
