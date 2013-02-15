//
//  Branch.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"

@interface Branch : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sha;

- (id)initWithData:(NSDictionary *)data;

- (NSString *)getUrl;
- (NSString *)getSha;

@end
