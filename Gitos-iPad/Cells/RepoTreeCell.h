//
//  RepoTreeCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoTreeNode.h"

@interface RepoTreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) RepoTreeNode *node;

- (void)render;

@end
