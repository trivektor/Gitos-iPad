//
//  Authorization.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 3/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (nonatomic, retain) NSDictionary *data;

- (id)initWithData:(NSDictionary *)authorizationData;

- (NSString *)getId;
- (NSString *)getUrl;
- (NSDictionary *)getApp;
- (NSString *)getName;
- (NSString *)getToken;
+ (NSArray *)appScopes;

@end
