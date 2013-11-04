//
//  RepoLanguagesViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/11/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoLanguagesViewController.h"

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

// Copied from http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end

@interface RepoLanguagesViewController ()

@end

@implementation RepoLanguagesViewController

@synthesize repo, distributions, languages, colorNames, pieChart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        colorNames = [[NSMutableArray alloc] initWithObjects:
            @"orange",
            @"alizarin",
            @"turquoise",
            @"pomegranate",
            @"belizeHole",
            @"greenSea",
            @"emerland",
            @"pumpkin",
            @"nephritis",
            @"peterRiver",
            @"amethyst",
            @"wisteria",
            @"sunflower",
            @"carrot",
            nil
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [repo fetchLanguages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Languages";
    pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(312, 162, 400, 400)];
    pieChart.pieRadius = 200;
    pieChart.delegate = self;
    pieChart.dataSource = self;
    pieChart.showPercentage = false;
    [self.view addSubview:pieChart];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayLanguages:)
                                                 name:@"RepoLanguagesFetched"
                                               object:nil];
}

- (void)fetchLanguages
{
    [repo fetchLanguages];
}

- (void)displayLanguages:(NSNotification *)notification
{
    distributions = (NSMutableArray *) notification.object;
    [pieChart reloadData];
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return distributions.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[[distributions objectAtIndex:index] valueForKey:@"percentage"] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    NSString *color = [NSString stringWithFormat:@"%@Color", [colorNames objectAtIndex:index]];
    return [UIColor performSelector:NSSelectorFromString(color)];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [[distributions objectAtIndex:index] valueForKey:@"name"];
}


@end
