//
//  JobCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JobCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong) Job *job;

- (void)render;

@end
