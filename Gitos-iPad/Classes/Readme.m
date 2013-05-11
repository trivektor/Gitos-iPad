//
//  Readme.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Readme.h"
#import "NSData+Base64.h"

@implementation Readme

@synthesize data;

- (id)initWithData:(NSDictionary *)readmeData
{
    self = [super init];
    data = readmeData;
    return self;
}

- (NSString *)getName
{
    return [data valueForKey:@"name"];
}

- (NSData *)getContent
{
    return [NSData dataFromBase64String:[data valueForKey:@"content"]];
}

@end
