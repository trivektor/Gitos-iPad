//
//  FeedbackViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize feedbackTable, nameCell, emailCell, messageCell, hud, nameField, emailField, messageField;

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
    [self performHouseKeepingTasks];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(sendFeedback)];

    [submitButton setTitleTextAttributes:@{
        NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:23]
    } forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)performHouseKeepingTasks
{
    [self performHousekeepingTasks];

    self.navigationItem.title = @"Feedback";
    self.navigationItem.hidesBackButton = YES;

    [feedbackTable setScrollEnabled:NO];
    [feedbackTable drawSeparator];
}

- (void)sendFeedback
{
    NSString *name    = nameField.text;
    NSString *email   = emailField.text;
    NSString *message = messageField.text;

    if (name.length == 0 || email.length == 0 || message.length == 0) {
        [AppHelper flashError:@"All fields are required" inView:self.view];
        return;
    }

    if ([messageField isFirstResponder]) {
        [messageField resignFirstResponder];
    }

    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];

    NSURL *url = [NSURL URLWithString:[AppConfig getConfigValue:@"GitosHost"]];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.nameField.text, @"name",
                                   self.emailField.text, @"from",
                                   self.messageField.text, @"text",
                                   nil];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSMutableURLRequest *postRequest = [httpClient requestWithMethod:@"POST" path:@"/feedback" parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:postRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         if ([[json valueForKey:@"success"] intValue] == 1) {
             [AppHelper flashAlert:@"Feedback submitted successfully" inView:self.view];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         NSLog(@"%@", error);
     }];

    [operation start];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 157;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nameCell;
    } else if (indexPath.row == 1) {
        return emailCell;
    } else {
        return messageCell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
