//
//  ReadmeViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ReadmeViewController.h"
#import "NSData+Base64.h"

@interface ReadmeViewController ()

@end

@implementation ReadmeViewController

@synthesize readme, fileView;

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
    self.navigationItem.title = [readme getName];
    [self displayReadmeContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayReadmeContent
{
    NSData *data = [readme getContent];
    [fileView loadData:data MIMEType:@"text/plain" textEncodingName:nil baseURL:nil];
}

@end
