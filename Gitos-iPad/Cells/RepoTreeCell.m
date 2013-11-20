//
//  RepoTreeCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeCell.h"

@implementation RepoTreeCell

@synthesize node, iconLabel, nameLabel;

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
    iconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:15.0];

    if ([node isTree]) {
        iconLabel.text      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-folder-close"];
    } else if ([node isBlob]) {
        iconLabel.text      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-file-alt"];
    }

    nameLabel.text = [node getPath];
    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[iconLabel, nameLabel]];
}

@end
