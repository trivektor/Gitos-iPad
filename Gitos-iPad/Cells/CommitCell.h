//
//  CommitCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commit.h"

@interface CommitCell : UITableViewCell

@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) Commit *commit;
@property (nonatomic, weak) IBOutlet UILabel *commentLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

- (void)render;
- (void)addShaLabel;

@end
