//
//  GistComment.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistComment.h"

@implementation GistComment

@synthesize data;

- (id)initWithData:(NSDictionary *)gistData
{
    self = [super init];
    data = gistData;
    return self;
}

@end
