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
//  HSListShowsInteractor.m
//  VIPER
//
//  Created by Hugo Sousa on 26/7/14.
//

#import "HSListShowsInteractor.h"

#import "HSListShowsDataManager.h"

typedef NS_ENUM(NSUInteger, Pagination)
{
    PaginationCurrent = 0,
    PaginationNext,
    PaginationPrevious
};

@interface HSListShowsInteractor ()

@property (nonatomic, strong) HSListShowsDataManager *dataManager;

@end


@implementation HSListShowsInteractor

- (instancetype)initWithDataManager:(HSListShowsDataManager *)dataManager
{
    self = [super init];
    if (self) {
        _dataManager = dataManager;
    }
    return self;
}

#pragma mark - Interactor Input
- (void)requestCurrentWeekTVShowEpisodes
{
    NSDate *beginOfCurrentWeek = [NSDate date];
    [self.dataManager findTVShowEpisodesWithStartDate:beginOfCurrentWeek
                                         numberOfDays:@7
                                    completionHandler:[self _executeOnFindTVShowEpisodesCompletionWithPaginationType:PaginationCurrent]];
}

- (void)requestNextWeekTVShowEpisodes
{
    NSDate *beginOfNextWeek = [NSDate date];
    [self.dataManager findTVShowEpisodesWithStartDate:beginOfNextWeek
                                         numberOfDays:@7
                                    completionHandler:[self _executeOnFindTVShowEpisodesCompletionWithPaginationType:PaginationNext]];
}

- (void)requestPreviousWeekTVShowEpisodes
{
    NSDate *beginOfPreviousWeek = [NSDate date];
    [self.dataManager findTVShowEpisodesWithStartDate:beginOfPreviousWeek
                                         numberOfDays:@7
                                    completionHandler:[self _executeOnFindTVShowEpisodesCompletionWithPaginationType:PaginationPrevious]];
}

#pragma mark - Private Methods
- (FindTVShowEpisodesCompletionHandler)_executeOnFindTVShowEpisodesCompletionWithPaginationType:(Pagination)paginationType
{
    __typeof__(self) __weak welf = self;
    
    return ^(NSArray *weekSchedule, NSError *error) {
        if (error) {
            [welf.output requestFailedWithError:error];
        } else {
            if (paginationType == PaginationPrevious) {
                [welf.output requestedPreviousWeekTVShowEpisodes:weekSchedule];
            } else if (paginationType == PaginationNext) {
                [welf.output requestedNextWeekTVShowEpisodes:weekSchedule];
            } else { // paginationCurrent
                [welf.output requestedCurrentWeekTVShowEpisodes:weekSchedule];
            }
        }
    };
}
@end
