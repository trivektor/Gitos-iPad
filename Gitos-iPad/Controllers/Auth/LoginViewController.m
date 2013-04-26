//
//  LoginViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "LoginViewController.h"
#import "AppInitialization.h"
#import "Authorization.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameCell, passwordCell, oauthParams, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oauthParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Authorization appScopes], @"scopes",
                                        CLIENT_ID, @"client_id",
                                        CLIENT_SECRET, @"client_secret",
                                        nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHousekeepingTasks];
    [self registerEvents];
    [self setDelegates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHousekeepingTasks
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
    hud.hidden = YES;

    [self.navigationItem setTitle:@"Login to Github"];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteExistingAuthorizations)];
    [submitButton setTintColor:[UIColor colorWithRed:202/255.0 green:0 blue:0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:submitButton];
    
    [loginTable setBackgroundView:nil];
    [loginTable setScrollEnabled:NO];
    [loginTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [loginTable setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
}

- (void)setDelegates
{
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return usernameCell;
    if (indexPath.row == 1) return passwordCell;
    return nil;
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticate)
                                                 name:@"ExistingAuthorizationsDeleted"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser)
                                                 name:@"UserAutheticated"
                                               object:nil];
}

- (void)authenticate
{
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];

    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:@"/authorizations" parameters:oauthParams];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         [hud setHidden:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         Authorization *authorization = [[Authorization alloc] initWithData:json];

         NSString *token = [authorization getToken];
         NSString *authorizationId = [authorization getId];
         NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];

         [SSKeychain setPassword:token forService:@"access_token" account:account];
         [SSKeychain setPassword:authorizationId forService:@"authorization_id" account:account];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAutheticated" object:nil];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [hud setHidden:YES];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

         [alert setMessage:[json valueForKey:@"message"]];
         [alert show];
     }];
    
    [operation start];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)deleteExistingAuthorizations
{
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];

    // Prompt if username of password was blank
    if (username.length == 0 || password.length == 0) {
        [AppHelper flashError:@"Please enter your username and password" inView:self.view];
        return;
    }

    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"GET" path:@"/authorizations" parameters:oauthParams];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];

        NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];
        NSString *storedAuthorizationId = [SSKeychain passwordForService:@"authorization_id" account:account];

        for (int i=0; i < [json count]; i++) {
            Authorization *authorization = [[Authorization alloc] initWithData:[json objectAtIndex:i]];

            NSString *authorizationId = [authorization getId];

            if ([[authorization getName] isEqualToString:@"Gitos"] && [authorizationId isEqualToString:storedAuthorizationId]) {

                NSLog(@"deleting existing authorization id: %@", storedAuthorizationId);

                NSMutableURLRequest *deleteRequest = [httpClient requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"/authorizations/%@", storedAuthorizationId] parameters:nil];
                AFHTTPRequestOperation *deleteOperation = [[AFHTTPRequestOperation alloc] initWithRequest:deleteRequest];

                [deleteOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExistingAuthorizationsDeleted" object:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@", error);
                }];
                [deleteOperation start];
                [hud setHidden:NO];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExistingAuthorizationsDeleted" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [operation start];
}

- (void)fetchUser
{
    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:@"/user"
                                                         parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         [hud setHidden:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         User *user = [[User alloc] initWithData:json];

         [AppInitialization run:self.view.window withUser:user];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {

     }];

    [operation start];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
