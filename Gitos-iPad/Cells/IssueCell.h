//
//  IssueCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface IssueCell : UITableViewCell

@property (nonatomic, strong) Issue *issue;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *overviewLabel;

@property (nonatomic, strong) IBOutlet UILabel *commentsLabel;

- (void) render;

@end
