//
//  RepoDetailsCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoDetailsCell.h"

@implementation RepoDetailsCell

@synthesize fieldLabel, fieldValue, repo;

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
        self.fieldLabel.text = @"Name";
        self.fieldValue.text = [self.repo getName];
    } else if (indexPath.row == 1) {
        self.fieldLabel.text = @"Forks";
        self.fieldValue.text = [NSString stringWithFormat:@"%i", [self.repo getForks]];
    } else if (indexPath.row == 2) {
        self.fieldLabel.text = @"Watchers";
        self.fieldValue.text = [NSString stringWithFormat:@"%i", [self.repo getWatchers]];
    } else if (indexPath.row == 3) {
        self.fieldLabel.text = @"Language";
        if ([self.repo getLanguage] == (id)[NSNull null]) {
            self.fieldValue.text = @"n/a";
        } else {
            self.fieldValue.text = [self.repo getLanguage];
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
