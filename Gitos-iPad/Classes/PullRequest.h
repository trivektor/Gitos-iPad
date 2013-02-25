//
//  PullRequest.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PullRequest : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)pullRequestData;
- (Repo *)getRepo;
- (NSDictionary *)getSubject;
- (NSString *)getTitle;
- (NSString *)getCommentsUrl;
- (User *)getOwner;
- (NSString *)getState;
- (NSString *)getBody;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)getClosedAt;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;

@end
