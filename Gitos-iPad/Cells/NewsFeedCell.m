//
//  NewsFeedCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell

@synthesize fontAwesomeLabel, actionDescription, actionDate;

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

- (void)displayEvent
{
    self.actionDescription.text = [self.event toString];
    self.actionDate.text        = [self.event toDateString];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    self.fontAwesomeLabel.font  = [UIFont fontWithName:kFontAwesomeFamilyName size:15.0];
    self.fontAwesomeLabel.text  = [NSString fontAwesomeIconStringForIconIdentifier:[self.event getFontAwesomeIcon]];
}

@end