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

@implementation CustomUITextField

@synthesize horizontalPadding, verticalPadding;

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + horizontalPadding, bounds.origin.y + verticalPadding, bounds.size.width - horizontalPadding*2, bounds.size.height - verticalPadding*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

@implementation FeedbackViewController

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
    [self applyCustomStyling];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedback)];
    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Feedback";
    self.navigationItem.hidesBackButton = YES;

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = YES;
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)applyCustomStyling
{
    NSArray *fields = @[self.nameField, self.emailField];

    UIView *namePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];

    self.nameField.leftView = namePaddingView;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;

    self.emailField.leftView = emailPaddingView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;

    for (UITextField *f in fields) {
        f.layer.borderColor   = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] CGColor];
        f.layer.borderWidth   = 1.0f;
        f.layer.cornerRadius  = 4.0f;
        f.layer.masksToBounds = YES;
    }

    self.messageField.layer.borderColor   = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] CGColor];
    self.messageField.layer.borderWidth   = 1.0f;
    self.messageField.layer.cornerRadius  = 4.0f;
    self.messageField.layer.masksToBounds = YES;
}

- (void)sendFeedback
{
    NSString *name    = self.nameField.text;
    NSString *email   = self.emailField.text;
    NSString *message = self.messageField.text;

    if (name.length == 0 || email.length == 0 || message.length == 0) {
        [YRDropdownView showDropdownInView:self.view
                                     title:@"Error"
                                    detail:@"All fields are required"
                                     image:[UIImage imageNamed:@"glyphicons_078_warning_sign.png"]
                                 textColor:[UIColor whiteColor]
                           backgroundColor:[UIColor colorWithRed:202/255.0 green:36/255.0 blue:36/255.0 alpha:1.0]
                                  animated:YES
                                 hideAfter:2.0f];
        return;
    }

    if ([self.messageField isFirstResponder]) {
        [self.messageField resignFirstResponder];
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
                                      hideAfter:2.0f];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud setHidden:YES];
         NSLog(@"%@", error);
     }];

    [operation start];
    [self.hud setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
