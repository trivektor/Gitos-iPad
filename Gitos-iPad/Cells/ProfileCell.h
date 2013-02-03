//
//  ProfileCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *fieldIcon;
@property (nonatomic, weak) IBOutlet UILabel *fontAwesomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *fieldDetails;

- (void)displayByIndexPath:(NSIndexPath *)indexPath forUser:(User *)user;

@end
