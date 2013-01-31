//
//  GistDetailsCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistDetailsCell.h"

@implementation GistDetailsCell

@synthesize gist, fieldLabel, fieldValue;

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

- (void)renderForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [fieldLabel setText:@"Files"];
        [fieldValue setText:[NSString stringWithFormat:@"%i", [self.gist getNumberOfFiles]]];
    } else if (indexPath.row == 1) {
        [fieldLabel setText:@"Forks"];
        [fieldValue setText:[NSString stringWithFormat:@"%i", [self.gist getNumberOfForks]]];
    } else if (indexPath.row == 2) {
        [fieldLabel setText:@"Comments"];
        [fieldValue setText:[NSString stringWithFormat:@"%i", [self.gist getNumberOfComments]]];
    }
}

@end
