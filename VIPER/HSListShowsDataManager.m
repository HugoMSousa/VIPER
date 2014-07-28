//
//  Copyright (C) 2014 Hugo Sousa.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//  HSListShowsDataManager.m
//  VIPER
//
//  Created by Hugo Sousa on 26/7/14.
//

#import "HSListShowsDataManager.h"

#import "HSCoreDataStore.h"
#import "HSTraktWebService.h"
#import "HSTVShowEpisode.h"

@interface HSListShowsDataManager ()

@property (nonatomic, strong) HSCoreDataStore *coreDataStore;
@property (nonatomic, strong) HSTraktWebService *traktWebService;

@end


@implementation HSListShowsDataManager

- (instancetype)initWithDataStore:(HSCoreDataStore *)dataStore traktWebService:(HSTraktWebService *)traktWebService
{
    self = [super init];
    if (self) {
        
        _coreDataStore = dataStore;
        _traktWebService = traktWebService;
    }
    return self;
}

- (void)findTVShowEpisodesWithStartDate:(NSDate *)startDate
                           numberOfDays:(NSNumber *)numberOfDays
                      completionHandler:(FindTVShowEpisodesCompletionHandler)completionHandler
{
    [self.traktWebService getTVShowEpisodesStartingAtDate:startDate numberOfDays:numberOfDays
                                        completionHandler:[self _executeOnGetTVShowEpisodesCompletion:completionHandler]];
}

#pragma mark - Private Methods
- (GetTVShowEpisodesCompletionHandler)_executeOnGetTVShowEpisodesCompletion:(FindTVShowEpisodesCompletionHandler)completionHandler
{
    return ^(NSURLResponse *response, NSArray *weekScheduleArray, NSError *error) {
        
        if (completionHandler) {
            completionHandler(weekScheduleArray, error);
        }
    };
}

@end
