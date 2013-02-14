//
//  CommitViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitViewController : UIViewController

@property (nonatomic, strong) NSString *branch;

- (void)performHouseKeepingTasks;

@end
