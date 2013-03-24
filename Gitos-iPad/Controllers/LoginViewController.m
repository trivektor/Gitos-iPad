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

@synthesize usernameCell, passwordCell, spinnerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHousekeepingTasks];
    [self setDelegates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHousekeepingTasks
{
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [self.spinnerView setHidden:YES];
    
    [self.navigationItem setTitle:@"Login to Github"];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteExistingAuthorizations)];
    [submitButton setTintColor:[UIColor colorWithRed:202/255.0 green:0 blue:0 alpha:1]];
    [self.navigationItem setRightBarButtonItem:submitButton];
    
    [loginTable setBackgroundView:nil];
    [loginTable setScrollEnabled:NO];
    [loginTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [loginTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
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

- (void)authenticate
{
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];

    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];

    NSMutableDictionary *oauthParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Authorization appScopes], @"scopes",
                                        CLIENT_ID, @"client_id",
                                        CLIENT_SECRET, @"client_secret",
                                        nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    
    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:@"/authorizations" parameters:oauthParams];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         [self.spinnerView setHidden:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         Authorization *authorization = [[Authorization alloc] initWithData:json];

         NSString *token = [authorization getToken];
         NSString *authorizationId = [authorization getId];
         NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];

         [SSKeychain setPassword:token forService:@"access_token" account:account];
         [SSKeychain setPassword:authorizationId forService:@"authorization_id" account:account];
         [AppInitialization run:self.view.window];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.spinnerView setHidden:YES];
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
        [YRDropdownView showDropdownInView:self.view title:@"Error" detail:@"Please enter your username and password" image:[UIImage imageNamed:@"glyphicons_078_warning_sign.png"] textColor:[UIColor colorWithRed:186/255.0 green:12/255.0 blue:12/255.0 alpha:1.0] backgroundColor:[UIColor whiteColor] animated:YES hideAfter:2.0f];
        return;
    }

    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GithubApiHost"]];
    
    NSMutableDictionary *oauthParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"75f198a854031c317e62", @"client_id",
                                        @"07d3e053d06132245799f4afe45b90d2780a89a8", @"client_secret",
                                        nil];

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
                    [self authenticate];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@", error);
                }];
                [deleteOperation start];
                [self.spinnerView setHidden:NO];
                return;
            }
        }
        [self authenticate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
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
