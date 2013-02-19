//
//  TimelineEvent.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Repo.h"

@interface TimelineEvent : NSObject

@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, strong) NSDate *todayDate;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property(nonatomic, strong) NSString *descriptionText;
@property(nonatomic, strong) NSDictionary *fontAwesomeIcons;

- (id)initWithData:(NSDictionary *)eventData;
- (NSString *)toString;
- (NSString *)getFontAwesomeIcon;
- (NSString *)toDateString;
- (NSDictionary *)getPayload;
- (NSDictionary *)getTarget;
- (NSString *)getType;
- (NSString *)getId;
- (User *)getActor;
- (Repo *)getRepo;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;

@end