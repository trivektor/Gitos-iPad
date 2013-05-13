//
//  Issue.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Issue : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)issueData;

- (NSString *)getLabelsUrl;
- (NSString *)getCommentsUrl;
- (NSString *)getHtmlUrl;
- (NSInteger)getNumber;
- (NSString *)getTitle;
- (User *)getUser;
- (NSString *)getState;
- (User *)getAssignee;
- (NSInteger)getNumberOfComments;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)getClosedAt;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getBody;

- (void)fetchCommentsForPage:(int)page;
- (void)createComment:(NSString *)comment;

@end
