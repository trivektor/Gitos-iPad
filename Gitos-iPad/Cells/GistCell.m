//
//  GistCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//


#import "GistCell.h"

@implementation GistCell

@synthesize fontAwesomeLabel, gist, gistName, gistCreatedAt, gistDescription;

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
    fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
    fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-code"];
    gistName.text         = [gist getName];
    gistDescription.text  = [gist getDescription];
    gistCreatedAt.text    = [gist getCreatedAt];
    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[fontAwesomeLabel, gistName, gistDescription, gistCreatedAt]];
}

@end
