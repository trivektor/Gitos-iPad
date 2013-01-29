//
//  OthersViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface OthersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UITableView *optionsTable;
}

@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) User *user;

@end