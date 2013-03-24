//
//  GistRawFileViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistRawFileViewController.h"

@interface GistRawFileViewController ()

@end

@implementation GistRawFileViewController

@synthesize fileWebView, theme, themes, themesOptions, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        themes = @[@"prettify.css", @"desert.css", @"sunburst.css", @"sons-of-obsidian.css", @"doxy.css"];
        theme = [themes objectAtIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchRawFile];
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:[self.gistFile getName]];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
}

- (void)fetchRawFile
{
    NSURL *fileUrl = [NSURL URLWithString:[self.gistFile getRawUrl]];
    NSURLRequest *fileRequest = [NSURLRequest requestWithURL:fileUrl];
    NSURLConnection *fileConnection = [NSURLConnection connectionWithRequest:fileRequest delegate:self];
    [fileConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    UIBarButtonItem *switchThemeButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch Theme" style:UIBarButtonItemStyleBordered target:self action:@selector(switchTheme)];

    self.navigationItem.rightBarButtonItem = switchThemeButton;

    NSString *rawFilePath = [[NSBundle mainBundle] pathForResource:@"raw_file" ofType:@"html"];
    NSString *rawFileContent = [NSString stringWithContentsOfFile:rawFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *htmlString = [NSString stringWithFormat:rawFileContent, theme, [self encodeHtmlEntities:content]];
    [fileWebView loadHTMLString:htmlString baseURL:baseURL];
    [fileWebView loadHTMLString:htmlString baseURL:baseURL];
    [hud hide:YES];
}

- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString
{
    return [[rawHtmlString
             stringByReplacingOccurrencesOfString: @">" withString: @"&#62;"]
            stringByReplacingOccurrencesOfString: @"<" withString: @"&#60;"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
}

- (void)switchTheme
{
    themesOptions = [[UIActionSheet alloc] initWithTitle:@"Choose Themes" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Default", @"Desert", @"Sunburst", @"Sons Of Obsidian", @"Doxy", nil];
    themesOptions.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [themesOptions showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != themesOptions.cancelButtonIndex) {
        theme = [themes objectAtIndex:buttonIndex];
        [self fetchRawFile];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
