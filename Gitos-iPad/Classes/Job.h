//
//  Job.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;

- (id)initWithData:(NSDictionary *)jobData;
- (NSString *)getTitle;
- (NSString *)getLocation;
- (NSString *)getType;
- (NSString *)getDescription;
- (NSString *)getHowToApply;
- (NSString *)getCompany;
- (NSString *)getCompanyLogo;
- (NSString *)getCompanyUrl;
- (NSString *)getUrl;

+ (void)fetchAll;

@end
