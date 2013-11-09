//
//  NotificationCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

@synthesize fontAwesomeLabel, notification, titleLabel, updatedAtLabel;

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
    fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];

    if ([notification isIssue]) {
        iconIdentifier = @"icon-warning-sign";
    } else if ([notification isPullRequest]) {
        iconIdentifier = @"icon-reply";
    }

    fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:iconIdentifier];
    titleLabel.text       = [notification getTitle];
    updatedAtLabel.text   = [notification getUpdatedAt];
    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[fontAwesomeLabel, titleLabel, updatedAtLabel]];
}

@end
