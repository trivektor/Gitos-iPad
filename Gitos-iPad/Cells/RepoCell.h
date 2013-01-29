//
//  RepoCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"

@interface RepoCell : UITableViewCell

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, weak) IBOutlet UILabel *repoNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *forkLabel;
@property (nonatomic, weak) IBOutlet UILabel *starLabel;

- (void)render;

@end
