//
//  AccountViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize url, pageTitle, webpageView;

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
    [self loadUrl];
    self.navigationItem.title = pageTitle;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-remove"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(cancel)];

    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)loadUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webpageView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
