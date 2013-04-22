//
//  DeleteEvent.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "TimelineEvent.h"

@interface DeleteEvent : TimelineEvent

- (NSMutableAttributedString *)toString;
- (NSString *)toHTMLString;

@end
