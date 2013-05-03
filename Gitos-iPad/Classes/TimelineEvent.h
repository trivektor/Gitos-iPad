//
//  TimelineEvent.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"
#import "User.h"

@interface TimelineEvent : NSObject

@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, strong) NSDate *todayDate;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property(nonatomic, strong) NSString *descriptionText;
@property(nonatomic, strong) NSDictionary *fontAwesomeIcons;

- (id)initWithData:(NSDictionary *)eventData;
- (NSMutableAttributedString *)toString;
- (NSMutableAttributedString *)toActorRepoString:(NSString *)actionName;
- (NSString *)toActorRepoHTMLString:(NSString *)actionName;

- (NSString *)getFontAwesomeIcon;
- (NSString *)toDateString;
- (NSDictionary *)getPayload;
- (NSDictionary *)getTarget;
- (NSString *)getType;
- (NSString *)getId;
- (User *)getActor;
- (User *)getTargetActor;
- (Repo *)getRepo;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSMutableAttributedString *)decorateEmphasizedText:(NSString *)rawString;
- (NSMutableAttributedString *)toAttributedString:(NSString *)rawString;
- (NSString *)toHTMLStringForObject1WithName:(NSString *)name1 AndAvatar1:(NSString *)avatar1 Object2:(NSString *)name2 AndAvatar2:(NSString *)avatar2 andAction:(NSString *)actionName;
- (NSString *)toHTMLStringForObject1WithName:(NSString *)name1 AndAvatar1:(NSString *)avatar1 Object2:(NSString *)name2 AndAvatar2:(NSString *)avatar2 andAction1:(NSString *)actionName1 Object3:(NSString *)name3 AndAvatar3:(NSString *)avatar3 andAction2:(NSString *)actionName2;


- (NSString *)toHTMLString;

@end