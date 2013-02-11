//
//  IssueDetailsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"
#import "MBProgressHUD.h"

@interface IssueDetailsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) Issue *issue;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, weak) IBOutlet UIWebView *detailsView;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *htmlString;

- (void)performHouseKeepingTasks;
- (void)fetchIssueDetails;
- (void)displayIssueDetails;

@end
