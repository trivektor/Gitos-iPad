//
//  CommitCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitCell.h"

@implementation CommitCell

@synthesize commentLabel, dateLabel, shaLabel;

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
    commentLabel.text  = [self.commit getMessage];
    dateLabel.text     = [self.commit getCommittedAt];
    shaLabel.text      = [[self.commit getSha] substringToIndex:10];
}

@end
