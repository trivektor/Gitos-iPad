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

@synthesize repo, languages, languagesTable, colorNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        colorNames = [[NSMutableArray alloc] initWithObjects:
            @"turquoise", @"greenSea",
            @"emerland", @"nephritis",
            @"peterRiver", @"belizeHole",
            @"amethyst", @"wisteria",
            @"sunflower", @"orange",
            @"carrot", @"pumpkin",
            @"alizarin", @"pomegranate", nil
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
    languages = (NSMutableDictionary *)notification.object;
    [languagesTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return languages.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [languagesTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    NSString *key = [[languages allKeys] objectAtIndex:indexPath.row];
    NSArray *values = [languages allValues];

    int total = 0;
    for (int i=0; i < values.count; i++) {
        total += [[values objectAtIndex:i] intValue];
    }

    float percentage = 100.0 * ([[values objectAtIndex:indexPath.row] floatValue] / total);
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.01f %%)", key, percentage];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    //cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;

    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 1024*percentage/100, 3)];

    [colorNames shuffle];
    NSString *color = [[colorNames objectAtIndex:indexPath.row] stringByAppendingString:@"Color"];

    SEL s = NSSelectorFromString(color);

    barView.backgroundColor = [UIColor performSelector:s];

    [cell addSubview:barView];
    [cell sendSubviewToBack:barView];

    return cell;
}

@end
