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
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    self.fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-quote-left"];
    self.titleLabel.text       = [self.notification getTitle];
    self.updatedAtLabel.text   = [self.notification getUpdatedAt];
}

@end
