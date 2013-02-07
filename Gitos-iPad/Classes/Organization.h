//
//  Organization.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)organizationData;

- (NSString *)getName;
- (NSString *)getEventsUrl;
- (NSString *)getUrl;
- (NSString *)getMembersUrl;
- (NSString *)getAvatarUrl;
- (NSString *)getReposUrl;
- (NSString *)getLogin;

@end
