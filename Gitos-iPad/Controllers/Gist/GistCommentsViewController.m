//
//  GistCommentsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistCommentsViewController.h"

@interface GistCommentsViewController ()

@end

@implementation GistCommentsViewController

@synthesize gist;

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
    [self registerEvents];
    [gist fetchComments];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayComments:)
                                                 name:@"GistCommentsFetched"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Comments";
}

- (void)displayComments:(NSNotification *)notification
{
    
}

@end
