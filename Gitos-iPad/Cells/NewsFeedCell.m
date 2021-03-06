//
//  NewsFeedCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell

@synthesize fontAwesomeLabel, actionDescription, event, actionDate, avatar;

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
    User *actor = [event getActor];
    actionDescription.attributedText = [event toString];
    actionDate.text                  = [event toDateString];
    fontAwesomeLabel.font            = [UIFont fontWithName:kFontAwesomeFamilyName size:15.0];
    fontAwesomeLabel.text            = [NSString fontAwesomeIconStringForIconIdentifier:[event getFontAwesomeIcon]];
    [avatar setImageWithURL:[NSURL URLWithString:[actor getAvatarUrl]] placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]];
    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[actionDescription, actionDate, fontAwesomeLabel]];
}

@end