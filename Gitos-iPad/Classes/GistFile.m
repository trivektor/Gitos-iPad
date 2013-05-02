//
//  GistFile.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistFile.h"

@implementation GistFile

@synthesize data;

- (id)initWithData:(NSDictionary *)gistData
{
    self = [super init];
    
    data = gistData;
    
    return self;
}

- (NSString *)getName
{
    return [data valueForKey:@"filename"];
}

- (NSString *)getRawUrl
{
    return [data valueForKey:@"raw_url"];
}

@end