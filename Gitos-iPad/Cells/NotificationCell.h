//
//  NotificationCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@interface NotificationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fontAwesomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *updatedAtLabel;
@property (nonatomic, strong) Notification *notification;

- (void)render;

@end
