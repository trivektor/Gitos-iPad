//
//  MasterViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/1/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DetailsViewController *detailsViewController;
@property (nonatomic, strong) UISplitViewController *parentViewController;
@property (nonatomic, weak) IBOutlet UITableView *menuTable;

@end