//
//  NewsFeedCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimelineEvent.h"

@interface NewsFeedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fontAwesomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *actionDescription;
@property (nonatomic, weak) IBOutlet UILabel *actionDate;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) TimelineEvent *event;

- (void)displayEvent;

@end