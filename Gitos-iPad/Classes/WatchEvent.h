//
//  WatchEvent.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchEvent : TimelineEvent

- (NSMutableAttributedString *)toString;
- (NSString *)toHTMLString;

@end
