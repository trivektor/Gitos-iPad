//
//  CommitCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitCell.h"
#import "SAMBadgeView.h"

@implementation CommitCell

@synthesize commentLabel, dateLabel, commit;

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
    commentLabel.text  = [commit getMessage];
    dateLabel.text     = [commit getCommittedAt];
    [self addShaLabel];
}

- (void)addShaLabel
{
    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[]];
}

@end
