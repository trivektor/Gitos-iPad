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
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedback)];
    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Feedback";
    self.navigationItem.hidesBackButton = YES;

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
    [hud hide:YES];

    [feedbackTable setBackgroundView:nil];
    [feedbackTable setScrollEnabled:NO];
    [feedbackTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [feedbackTable setSeparatorColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.8]];
}

- (void)sendFeedback
{
    NSString *name    = nameField.text;
    NSString *email   = emailField.text;
    NSString *message = messageField.text;

    if (name.length == 0 || email.length == 0 || message.length == 0) {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"Error"
                                    detail:@"All fields are required"
                                     image:[UIImage imageNamed:@"glyphicons_078_warning_sign.png"]
                                 textColor:[UIColor colorWithRed:186/255.0 green:12/255.0 blue:12/255.0 alpha:1.0]
                           backgroundColor:[UIColor whiteColor]
                                  animated:YES
                                 hideAfter:HIDE_AFTER];
        return;
    }

    if ([messageField isFirstResponder]) {
        [messageField resignFirstResponder];
    }

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
         [self.hud setHidden:YES];
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         if ([[json valueForKey:@"success"] intValue] == 1) {
             [YRDropdownView showDropdownInView:self.view
                                          title:@"Alert"
                                         detail:@"Feedback submitted successfully"
                                          image:[UIImage imageNamed:@"glyphicons_198_ok.png"]
                                      textColor:[UIColor whiteColor]
                                backgroundColor:[UIColor colorWithRed:87/255.0 green:153/255.0 blue:38/255.0 alpha:1.0]
                                       animated:YES
                                      hideAfter:HIDE_AFTER];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud setHidden:YES];
         NSLog(@"%@", error);
     }];

    [operation start];
    [self.hud setHidden:NO];
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
