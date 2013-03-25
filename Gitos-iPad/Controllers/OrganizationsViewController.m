//
//  OrganizationsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "OrganizationsViewController.h"
#import "Organization.h"
#import "OrganizationViewController.h"

@interface OrganizationsViewController ()

@end

@implementation OrganizationsViewController

@synthesize organizationsTable, hud, accessToken, user, organizations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];

        self.organizations = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchOrganizations];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Organizations";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)fetchOrganizations
{
    NSURL *organizationsUrl = [NSURL URLWithString:[self.user getOrganizationsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:organizationsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:organizationsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         for (int i=0; i < json.count; i++) {
             [self.organizations addObject:[[Organization alloc] initWithData:[json objectAtIndex:i]]];
         }
         [organizationsTable reloadData];
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
    return [self.organizations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [organizationsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    Organization *org = [self.organizations objectAtIndex:indexPath.row];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[org getAvatarUrl]]];

    cell.imageView.image = [UIImage imageWithData:data];
    cell.textLabel.text = [org getLogin];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationViewController *organizationController = [[OrganizationViewController alloc] init];
    organizationController.organization = [self.organizations objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:organizationController animated:YES];
}

@end
