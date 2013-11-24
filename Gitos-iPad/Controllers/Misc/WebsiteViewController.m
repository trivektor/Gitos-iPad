//
//  WebsiteViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "WebsiteViewController.h"

@interface WebsiteViewController ()

@end

@implementation WebsiteViewController

@synthesize requestedUrl, websiteView, hud;

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
    [self loadWebsite];
}

- (void)performHouseKeepingTasks
{
}

- (void)showOptions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", @"Mail link", @"Copy link", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebsite
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestedUrl]];
    
    [websiteView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
    self.navigationItem.title = [websiteView stringByEvaluatingJavaScriptFromString:@"document.title"];
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-share"] style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showOptions)];
    [optionsButton setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontAwesomeFamilyName size:23]
    } forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = optionsButton;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openInSafari];
    } else if (buttonIndex == 1) {
        [self mailLink];
    } else if (buttonIndex == 2) {
        [self copyLink];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openInSafari
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestedUrl]];
}

- (void)mailLink
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"Profile website link"];
    [mailViewController setMessageBody:requestedUrl isHTML:YES];
    [self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)copyLink
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = requestedUrl;
}

@end
