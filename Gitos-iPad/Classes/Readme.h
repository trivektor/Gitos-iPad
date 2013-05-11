//
//  Readme.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Readme : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)readmeData;

- (NSString *)getName;
- (NSData *)getContent;

@end
