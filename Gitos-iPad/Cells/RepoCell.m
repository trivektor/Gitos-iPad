//
//  RepoCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCell.h"

@implementation RepoCell

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
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];

    if (self.repo.isForked) {
        self.fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-random"];
    } else {
        self.fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-book"];
    }
    self.repoNameLabel.text = [self.repo getName];
    
    // Float the Forks and Watchers labels side by side
    // http://stackoverflow.com/questions/5891384/place-two-uilabels-side-by-side-left-and-right-without-knowing-string-length-of
    
    NSInteger _forks = [self.repo getForks];
    NSString *forks;
    
    NSInteger MAX_COUNT = 1000.0;
    
    if (_forks > MAX_COUNT) {
        forks = [NSString stringWithFormat:@"%.1fk", _forks/MAX_COUNT*1.0];
    } else {
        forks = [NSString stringWithFormat:@"%i", _forks];
    }
    
    NSInteger _watchers = [self.repo getWatchers];
    NSString *watchers;
    
    if (_watchers > MAX_COUNT) {
        watchers = [NSString stringWithFormat:@"%.1fk", _watchers/MAX_COUNT*1.0];
    } else {
        watchers = [NSString stringWithFormat:@"%i", _watchers];
    }
    
    CGSize forksSize = [forks sizeWithFont:self.forkLabel.font];
    CGSize watchersSize = [watchers sizeWithFont:self.starLabel.font];
    
    self.forkLabel.text = forks;
    self.starLabel.text = watchers;
    
    self.forkLabel.frame = CGRectMake(self.forkLabel.frame.origin.x,
                                      self.forkLabel.frame.origin.y,
                                      forksSize.width,
                                      forksSize.height);
    
    self.starLabel.frame = CGRectMake(self.starLabel.frame.origin.x,
                                      self.starLabel.frame.origin.y,
                                      watchersSize.width,
                                      watchersSize.height);
    
    self.descriptionLabel.text = [self.repo getDescription];

    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
}

@end
