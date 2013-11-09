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
    SAMBadgeView *shaLabel = [[SAMBadgeView alloc] initWithFrame:CGRectMake(871, 17, 180, 21)];
    shaLabel.textLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    shaLabel.textLabel.text = [[commit getSha] substringToIndex:10];
    shaLabel.textLabel.highlightedTextColor = [UIColor asbestosColor];
    shaLabel.badgeColor = [UIColor silverColor];
    shaLabel.cornerRadius = 4.0;
    [self addSubview:shaLabel];
    [self defineHighlightedColorsForLabels:@[shaLabel]];
}

@end
