//
//  Notification.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"

@interface Notification : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)notificationData;
- (Repo *)getRepo;
- (NSDictionary *)getSubjectData;
- (NSString *)getTitle;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getUpdatedAt;
- (BOOL)isUnread;
- (NSString *)getSubjectUrl;
- (NSString *)getSubjectType;

@end
