//
//  HSTraktWebService.m
//  VIPER
//
//  Created by Hugo Sousa on 22/7/14.
//  Copyright (c) 2014 muzzley. All rights reserved.
//

#import "HSTraktWebService.h"

#import "HSTVShowEpisode.h"
#import "HSTVShowDaySchedule.h"

@interface HSTraktWebService ()

@property (nonatomic,copy) NSString *traktAPIKey;
@property (nonatomic,copy) NSString *username;

@end


@implementation HSTraktWebService

- (instancetype)initWithBaseURL:(NSURL *)url traktAPIKey:(NSString *)key username:(NSString *)username
{
    self = [super initWithBaseURL:url sessionConfiguration:nil];
    if (self) {
        [self _configureWithTraktAPIKey:key username:username];
    }
    return self;
}

- (void)_configureWithTraktAPIKey:(NSString *)key username:(NSString *)username
{
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.traktAPIKey = key;
    self.username = username;
}

- (NSString *)_stringFromDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter stringFromDate:date];
}

- (NSString *)_buildPathComponentStringWithPath:(NSString *)path
                                    traktAPIKey:(NSString *)traktAPIKey
                                       username:(NSString *)username
                                           date:(NSDate *)date
                                   numberOfdays:(NSNumber *)numberOfDays
{
    NSString *dateString = [self _stringFromDate:date dateFormat:@"yyyyMMdd"];
    
    return [NSString stringWithFormat:@"%@/%@/%@/%@/%ld",path, traktAPIKey, username, dateString, (long)[numberOfDays integerValue]];
}

/*
    - Format the specified date with @"yyyyMMdd" format.
    - Build path component: 'user/calendar/shows.json/{traktApiKey}/{username}/{date}/{numberOfDays}"
*/
- (void)getTVShowEpisodesStartingAtDate:(NSDate *)startDate
                           numberOfDays:(NSNumber *)numberOfDays
                      completionHandler:(GetTVShowEpisodesCompletionHandler)completionHandler
{
    NSString *path = [self _buildPathComponentStringWithPath:@"user/calendar/shows.json"
                                                 traktAPIKey:_traktAPIKey
                                                    username:_username
                                                        date:startDate
                                                numberOfdays:numberOfDays];
    
    [self GET:path parameters:nil
      success:[self _executeOnGetShowsSuccess:completionHandler]
      failure:[self _executeOnGetShowsFailure:completionHandler]];
}

- (void (^)(NSURLSessionDataTask *, id))_executeOnGetShowsSuccess:(GetTVShowEpisodesCompletionHandler)completionHandler
{
    __typeof__(self) __weak welf = self;
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        if (completionHandler) {
            
            NSArray *rawData = [responseObject isKindOfClass:[NSArray class]] ? responseObject : [NSArray new];
            NSArray *weekSchedule = [welf _tvShowEpisodesWeekScheduleFromJSONResponseSerializerRawData:rawData];
            
            completionHandler(task.response, weekSchedule, nil);
        }
    };
}

- (void (^)(NSURLSessionDataTask *, NSError *))_executeOnGetShowsFailure:(GetTVShowEpisodesCompletionHandler)completionHandler
{
    return ^(NSURLSessionDataTask *task, NSError *error) {
        if (completionHandler) {
            completionHandler(task.response, nil, error);
        }
    };
}

- (NSArray *)_tvShowEpisodesWeekScheduleFromJSONResponseSerializerRawData:(NSArray *)rawData
{
    NSMutableArray *weekSchedule = [NSMutableArray new];
    
    for (NSInteger i = rawData.count - 1; i >= 0 ; i--) {
        NSDictionary *eachDaySchedule = rawData[i];
        
        if(![eachDaySchedule isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        HSTVShowDaySchedule *daySchedule = [HSTVShowDaySchedule new];
        daySchedule.date =  eachDaySchedule[@"date"];
        
        NSMutableArray *dayEpisodesToAdd = [NSMutableArray new];
        NSArray *dayEpisodes = eachDaySchedule[@"episodes"];
        for (NSDictionary *episodeDict in dayEpisodes) {
            
            HSTVShowEpisode *episode = [HSTVShowEpisode new];
            episode.showName =       [episodeDict valueForKeyPath:@"show.title"];
            episode.seasonNumber =   [episodeDict valueForKeyPath:@"episode.season"];
            episode.episodeNumber =  [episodeDict valueForKeyPath:@"episode.number"];
            episode.imdbId =         [episodeDict valueForKeyPath:@"show.imdb_id"];
            episode.network =        [episodeDict valueForKeyPath:@"show.network"];
            episode.certification =  [episodeDict valueForKeyPath:@"show.certification"];
            episode.country =        [episodeDict valueForKeyPath:@"show.country"];
            episode.airTime =        [episodeDict valueForKeyPath:@"show.air_time_localized"];
            episode.imageUrlString = [episodeDict valueForKeyPath:@"show.images.poster"];
            episode.overview =       [episodeDict valueForKeyPath:@"show.overview"];
            [dayEpisodesToAdd addObject:episode];
        }
        daySchedule.tvShowEpisodes = dayEpisodesToAdd;
        [weekSchedule addObject:daySchedule];
    }
    return weekSchedule;
}

/*
{
    date = "2014-07-28";
    episodes =     (
                    {
                        episode =             {
                            "first_aired" = 1406615400;
                            "first_aired_iso" = "2014-07-28T23:30:00-04:00";
                            "first_aired_localized" = 1406615400;
                            "first_aired_utc" = 1406604600;
                            images =                 {
                                screen = "http://slurm.trakt.us/images/fanart/293-940.1.jpg";
                            };
                            number = 135;
                            overview = "";
                            ratings =                 {
                                hated = 0;
                                loved = 0;
                                percentage = 0;
                                votes = 0;
                            };
                            season = 10;
                            title = Beck;
                            url = "http://trakt.tv/show/the-colbert-report/season/10/episode/135";
                        };
                        show =             {
                            "air_day" = Friday;
                            "air_day_localized" = Friday;
                            "air_day_utc" = Friday;
                            "air_time" = "11:30pm";
                            "air_time_localized" = "11:30pm";
                            "air_time_utc" = "8:30pm";
                            certification = "TV-14";
                            country = "United States";
                            "first_aired" = 1128753000;
                            "first_aired_iso" = "2005-10-07T23:30:00-04:00";
                            "first_aired_localized" = 1128753000;
                            "first_aired_utc" = 1128742200;
                            genres =                 (
                                                      Comedy,
                                                      News,
                                                      "Talk Show"
                                                      );
                            images =                 {
                                banner = "http://slurm.trakt.us/images/banners/293.1.jpg";
                                fanart = "http://slurm.trakt.us/images/fanart/293.1.jpg";
                                poster = "http://slurm.trakt.us/images/posters/293.1.jpg";
                            };
                            "imdb_id" = tt0458254;
                            network = "Comedy Central";
                            overview = "Tune in to The Colbert Report, as Stephen Colbert gives his own take on the issues of the day, and more importantly, to tell you why everyone else's take is just plain wrong.  The series is a variety/news show revolving around Colbert's TV persona, a parody of opinionated cable news personalities like Bill O'Reilly, Sean Hannity, and Joe Scarborough.";
                            ratings =                 {
                                hated = 43;
                                loved = 1157;
                                percentage = 89;
                                votes = 1200;
                            };
                            runtime = 30;
                            title = "The Colbert Report";
                            "tvdb_id" = 79274;
                            "tvrage_id" = 6715;
                            url = "http://trakt.tv/show/the-colbert-report";
                            year = 2005;
                        };
                    }
                    );
}*/
@end
