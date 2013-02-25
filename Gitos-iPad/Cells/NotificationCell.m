//
//  NotificationCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)render
{
    NSString *iconIdentifier;
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    if (self.notification.isIssue) {
        iconIdentifier = @"icon-warning-sign";
    } else if (self.notification.isPullRequest) {
        iconIdentifier = @"icon-reply";
    }
    self.fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:iconIdentifier];
    self.titleLabel.text       = [self.notification getTitle];
    self.updatedAtLabel.text   = [self.notification getUpdatedAt];
    self.accessoryType         = UITableViewCellAccessoryDisclosureIndicator;
}

@end
