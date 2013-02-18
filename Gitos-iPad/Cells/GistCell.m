//
//  GistCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//


#import "GistCell.h"

@implementation GistCell

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
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
    self.fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-pushpin"];
    self.gistName.text         = [self.gist getName];
    self.gistDescription.text  = [self.gist getDescription];
    self.gistCreatedAt.text    = [self.gist getCreatedAt];
    self.accessoryType         = UITableViewCellAccessoryDisclosureIndicator;
}

@end
