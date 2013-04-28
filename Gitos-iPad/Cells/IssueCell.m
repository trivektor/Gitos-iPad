//
//  IssueCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueCell.h"

@implementation IssueCell

@synthesize issue, titleLabel, commentsLabel, overviewLabel;

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
    User *user = [self.issue getUser];

    NSString *title = [[issue getTitle] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    titleLabel.text = [NSString stringWithFormat:@"#%i %@", [issue getNumber], title];
    overviewLabel.text = [NSString stringWithFormat:@"by %@ %@", [user getLogin], [issue getCreatedAt]];
    commentsLabel.text = [NSString stringWithFormat:@"%i comments", [self.issue getNumberOfComments]];
}

@end
