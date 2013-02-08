//
//  Organization.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelativeDateDescriptor.h"

@interface Organization : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)organizationData;

- (NSString *)getName;
- (NSString *)getLocation;
- (NSString *)getEventsUrl;
- (NSString *)getUrl;
- (NSString *)getMembersUrl;
- (NSString *)getAvatarUrl;
- (NSString *)getReposUrl;
- (NSString *)getLogin;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getWebsite;
- (NSInteger)getNumberOfRepos;
- (NSInteger)getNumberOfFollowers;
- (NSInteger)getNumberOfFollowing;

@end
