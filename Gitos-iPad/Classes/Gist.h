//
//  Gist.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gist : NSObject

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSDictionary *details;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)gistData;

- (NSString *)getId;
- (NSString *)getName;
- (NSString *)getDescription;
- (NSString *)getCreatedAt;
- (NSInteger)getNumberOfForks;
- (NSInteger)getNumberOfFiles;
- (NSDictionary *)getFiles;
- (NSArray *)getGistFiles;
- (NSInteger)getNumberOfComments;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (void)fetchStats;
+ (void)save:(NSDictionary *)data;

@end