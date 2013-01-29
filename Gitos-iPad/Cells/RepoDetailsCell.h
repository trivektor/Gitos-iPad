//
//  RepoDetailsCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"

@interface RepoDetailsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *fieldLabel;
@property (nonatomic, strong) IBOutlet UILabel *fieldValue;
@property (nonatomic, strong) Repo *repo;

- (void)renderForIndexPath:(NSIndexPath *)indexPath;

@end