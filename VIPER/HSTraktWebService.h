//
//  HSTraktWebService.h
//  VIPER
//
//  Created by Hugo Sousa on 22/7/14.
//  Copyright (c) 2014 muzzley. All rights reserved.
//

#import "AFHTTPSessionManager.h"


typedef void (^GetTVShowEpisodesCompletionHandler)(NSURLResponse *response, NSArray *shows, NSError *error);


@interface HSTraktWebService : AFHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url traktAPIKey:(NSString *)key username:(NSString *)username;

- (void)getTVShowEpisodesStartingAtDate:(NSDate *)startDate
                           numberOfDays:(NSNumber *)numberOfDays
                      completionHandler:(GetTVShowEpisodesCompletionHandler)completionHandler;
@end
