//
//  GistComment.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GistComment : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSString *createdAt;

- (id)initWithData:(NSDictionary *)gistData;
- (User *)getUser;
- (NSString *)getBody;
- (NSString *)getCreatedAt;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;

@end
