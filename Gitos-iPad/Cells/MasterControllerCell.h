//
//  MasterControllerCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/3/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterControllerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fontAwesomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *optionLabel;

- (void)renderForIndexPath:(NSIndexPath *)indexPath;

@end
