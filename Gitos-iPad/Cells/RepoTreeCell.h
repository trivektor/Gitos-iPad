//
//  RepoTreeCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoTreeNode.h"

@interface RepoTreeCell : UITableViewCell

@property (nonatomic, strong) RepoTreeNode *node;

- (void)render;

@end
