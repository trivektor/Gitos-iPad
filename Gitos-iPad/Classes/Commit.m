//
//  Commit.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Commit.h"
#import "CommitFile.h"

@implementation Commit

@synthesize data, relativeDateDescriptor, dateFormatter;

static NSString *DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:ssZZ";

- (id)initWithData:(NSDictionary *)commitData
{
    self = [super init];
    data = commitData;
    relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    return self;
}

- (NSString *)getSha
{
    return [data valueForKey:@"sha"];
}

- (NSString *)getUrl
{
    return [data valueForKey:@"url"];
}

- (NSString *)getCommentsUrl
{
    return [data valueForKey:@"url"];
}

- (NSDictionary *)getDetails
{
    return [data valueForKey:@"commit"];
}

- (NSString *)getMessage
{
    NSDictionary *details = [self getDetails];
    return [details valueForKey:@"message"];
}

- (NSDictionary *)getParent
{
    return [data valueForKey:@"parents"];
}

- (NSString *)getParentSha
{
    NSDictionary *parent = [self getParent];
    return [parent valueForKey:@"sha"];
}

- (NSString *)getParentUrl
{
    NSDictionary *parent = [self getParent];
    return [parent valueForKey:@"parent"];
}

- (NSDictionary *)getStats
{
    return [data valueForKey:@"status"];
}

- (NSArray *)getFiles
{
    return [data valueForKey:@"files"];
}

- (User *)getAuthor
{
    return [[User alloc] initWithData:[data valueForKey:@"author"]];
}

- (NSString *)getCommittedAt
{
    NSDictionary *details = [self getDetails];
    NSDictionary *author = [details valueForKey:@"author"];
    NSString *dateString = [author valueForKey:@"date"];
    NSDate *date  = [dateFormatter dateFromString:dateString];
    return [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

- (void)fetchDetails
{
    NSURL *commitsUrl = [NSURL URLWithString:[self getUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commitsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:commitsUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"CommitDetailsFetched"
                                                             object:[[Commit alloc] initWithData:json]];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (NSString *)toHTMLString
{
    NSString *commitHtmlString = @"";
    NSArray *files = [self getFiles];
    User *author = [self getAuthor];

    NSString *commitMessageString = [NSString stringWithFormat:@" \
                                     <tr id='commit-overview'> \
                                     <td> \
                                     <h4>%@</h4> \
                                     <p> \
                                     <img src='%@' class='avatar pull-left' /> \
                                     authored %@ \
                                     </p> \
                                     </td> \
                                     </tr>",
                                     [self getMessage],
                                     [author getAvatarUrl],
                                     [self getCommittedAt]];

    commitMessageString = [commitMessageString stringByAppendingFormat:@" \
                           <tr> \
                           <td>Showing %i changed %@</td> \
                           </tr>",
                           [files count],
                           [files count] > 1 ? @"files" : @"file"];

    NSString *markupString = @" \
    <tr> \
    <td> \
    <div class='clearfix'> \
    <b class='pull-left'>%@</b> \
    <span class='pull-right commit-stats'> \
    <b>%@</b> \
    <label class='label label-success'>%@</label> \
    <label class='label label-important'>%@</label> \
    </span> \
    </div> \
    <pre><code>%@</code></pre> \
    </td> \
    </tr>";

    for (int i=0; i < files.count; i++) {
        CommitFile *file = [[CommitFile alloc] initWithData:[files objectAtIndex:i]];
        NSInteger additions = [file getAdditions], deletions = [file getDeletions];

        commitHtmlString = [commitHtmlString stringByAppendingFormat:markupString,
                            [file getFileName],
                            [NSString stringWithFormat:@"%i", (additions + deletions)],
                            [NSString stringWithFormat:@"%i %@", additions, additions > 1 ? @"additions" : @"addition"],
                            [NSString stringWithFormat:@"%i %@", deletions, deletions > 1 ? @"deletions" : @"deletion"],
                            [self encodeHtmlEntities:[file getPatch]]];
    }

    NSString *commitDetailsPath = [[NSBundle mainBundle] pathForResource:@"commit_details"
                                                                  ofType:@"html"];

    NSString *commitDetails = [NSString stringWithContentsOfFile:commitDetailsPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];

    NSString *contentHtml = [NSString stringWithFormat:commitDetails, commitMessageString, commitHtmlString];

    return contentHtml;
}

- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString
{
    return [[rawHtmlString
             stringByReplacingOccurrencesOfString: @">" withString: @"&#62;"]
            stringByReplacingOccurrencesOfString: @"<" withString: @"&#60;"];
}

@end
