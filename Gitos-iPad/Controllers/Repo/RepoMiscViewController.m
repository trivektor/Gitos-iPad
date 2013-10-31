//
//  RepoMiscViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/3/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoMiscViewController.h"

#define NUM_OF_SECTIONS 4

@interface RepoMiscViewController ()

@end

@implementation RepoMiscViewController

@synthesize halfModal, contributorsBtn, commitsActivityBtn, punchCardBtn, closeModalBtn;

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
    self.view.backgroundColor = [UIColor clearColor];
    [self setupOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupOptions
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    // Contributors
    NSString *iconGroup = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
    contributorsBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
    [contributorsBtn setTitle:iconGroup forState:UIControlStateNormal];
    [contributorsBtn setTitle:iconGroup forState:UIControlEventTouchDown];
    [contributorsBtn setTitleColor:[UIColor alizarinColor] forState:UIControlStateNormal];
    [contributorsBtn setTitleColor:[UIColor alizarinColor] forState:UIControlEventTouchDown];
    [contributorsBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(31, 11, 110, 21)];
    label1.font = font;
    label1.textColor = [UIColor alizarinColor];
    label1.text = @"Contributors";
    
    [contributorsBtn addSubview:label1];
    
    // Commits Activity
    NSString *iconBarChart = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-upload"];
    commitsActivityBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
    [commitsActivityBtn setTitle:iconBarChart forState:UIControlStateNormal];
    [commitsActivityBtn setTitle:iconBarChart forState:UIControlEventTouchDown];
    [commitsActivityBtn setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [commitsActivityBtn setTitleColor:[UIColor peterRiverColor] forState:UIControlEventTouchDown];
    [commitsActivityBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(31, 11, 150, 21)];
    label2.font = font;
    label2.textColor = [UIColor peterRiverColor];
    label2.text = @"Commits Activity";
    
    [commitsActivityBtn addSubview:label2];
    
    // Punch Card
    NSString *iconTime = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-time"];
    punchCardBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
    [punchCardBtn setTitle:iconTime forState:UIControlStateNormal];
    [punchCardBtn setTitle:iconTime forState:UIControlEventTouchDown];
    [punchCardBtn setTitleColor:[UIColor emerlandColor] forState:UIControlStateNormal];
    [punchCardBtn setTitleColor:[UIColor emerlandColor] forState:UIControlEventTouchDown];
    [punchCardBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(31, 11, 90, 21)];
    label3.font = font;
    label3.textColor = [UIColor emerlandColor];
    label3.text = @"Punch Card";
    
    [punchCardBtn addSubview:label3];
    
    // Close button
    NSString *iconRemoveCircle = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-remove-circle"];
    closeModalBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
    [closeModalBtn setTitle:iconRemoveCircle forState:UIControlStateNormal];
    [closeModalBtn setTitle:iconRemoveCircle forState:UIControlEventTouchDown];
    [closeModalBtn setTitleColor:[UIColor pomegranateColor] forState:UIControlStateNormal];
    [closeModalBtn setTitleColor:[UIColor pomegranateColor] forState:UIControlEventTouchDown];
}

- (void)showContributors:(id)sender
{
    [self postCloseMiscModalNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRepoMiscInfo"
                                                        object:@"RepoContributors"];
}

- (void)showCommitsActivity:(id)sender
{
    [self postCloseMiscModalNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRepoMiscInfo"
                                                        object:@"RepoCommitActivity"];
}

- (void)showPunchCard:(id)sender
{
    [self postCloseMiscModalNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRepoMiscInfo"
                                                        object:@"RepoPunchCard"];
}

- (IBAction)closeModal:(id)sender
{
    [self postCloseMiscModalNotification];
}

- (void)postCloseMiscModalNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRepoMiscModal"
                                                        object:nil];
}

@end
