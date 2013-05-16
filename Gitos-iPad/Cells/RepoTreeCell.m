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
    iconLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:19];

    if ([node isTree]) {
        iconLabel.text      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-folder-close"];
        iconLabel.textColor = [UIColor colorWithRed:148/255.0
                                              green:148/255.0
                                               blue:148/255.0
                                              alpha:1.0];
    } else if ([node isBlob]) {
        iconLabel.text      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-file"];
        iconLabel.textColor = [UIColor blackColor];
    }

    nameLabel.text = [node getPath];
    self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor peterRiverColor];

    self.selectedBackgroundView = backgroundView;

}

@end
