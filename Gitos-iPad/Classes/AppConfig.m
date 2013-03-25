//
//  AppConfig.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation AppConfig

+ (NSString *)getConfigValue:(NSString *)valueName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings valueForKey:valueName];
}

@end
