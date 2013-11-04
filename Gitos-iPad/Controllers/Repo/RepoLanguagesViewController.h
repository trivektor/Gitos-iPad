//
//  RepoLanguagesViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/11/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface RepoLanguagesViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSMutableDictionary *languages;
@property (nonatomic, strong) NSMutableArray *distributions;
@property (nonatomic, strong) NSMutableArray *colorNames;
@property (nonatomic, strong) XYPieChart *pieChart;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)fetchLanguages;
- (void)displayLanguages:(NSNotification *)notification;

@end
