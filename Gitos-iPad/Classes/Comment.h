//
//  Comment.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSString *createdAt;

- (id)initWithData:(NSDictionary *)commentData;

- (User *)getUser;
- (NSString *)getBody;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;

@end
