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
@property (nonatomic, weak) IBOutlet UILabel *fontAwesomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *forkIconLabel;
@property (nonatomic, weak) IBOutlet UILabel *forkLabel;
@property (weak, nonatomic) IBOutlet UILabel *starIconLabel;
@property (nonatomic, weak) IBOutlet UILabel *starLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (void)render;

@end
