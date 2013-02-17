//
//  UserSearchResultCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserSearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) User *user;

- (void)render;

@end
