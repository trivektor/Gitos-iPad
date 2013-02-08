//
//  OrganizationViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "SpinnerView.h"

@interface OrganizationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *organizationTable;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) SpinnerView *spinnerView;
@property (nonatomic, strong) Organization *organization;

- (void)performHouseKeepingTasks;
- (void)fetchOrganizationInfo;

@end
