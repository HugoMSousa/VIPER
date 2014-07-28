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
//
//  HSListShowsPresenter.m
//  VIPER
//
//  Created by Hugo Sousa on 27/7/14.
//

#import "HSListShowsPresenter.h"

#import "HSListShowsViewInterface.h"

@interface HSListShowsPresenter ()

@property (nonatomic, strong, readwrite) id<HSListShowsInteractorInput> interactor;
@property (nonatomic, strong, readwrite) HSListShowsWireframe *wireframe;

@end

@implementation HSListShowsPresenter

- (instancetype)initWithInteractor:(id<HSListShowsInteractorInput>)interactor wireframe:(HSListShowsWireframe *)wireframe
{
    self = [super init];
    if (self) {
        _interactor = interactor;
        _wireframe = wireframe;
    }
    return self;
}

#pragma mark - HSListShowsModuleInterface
- (void)updateListWithCurrentWeekItems
{
    [self.interactor requestCurrentWeekTVShowEpisodes];
}

- (void)updateListWithNextWeekItems
{
    [self.interactor requestNextWeekTVShowEpisodes];
}

-(void)updateListWithPreviousWeekItems
{
    [self.interactor requestPreviousWeekTVShowEpisodes];
}


#pragma mark - HSListShowsInteractorOutput
- (void)requestedCurrentWeekTVShowEpisodes:(NSArray *)weekSchedule
{
    [self.userInterface insertNextWeekSchedule:weekSchedule];
}

- (void)requestedNextWeekTVShowEpisodes:(NSArray *)weekSchedule
{
    [self.userInterface insertNextWeekSchedule:weekSchedule];
}

- (void)requestedPreviousWeekTVShowEpisodes:(NSArray *)weekSchedule
{
    [self.userInterface insertPreviousWeekSchedule:weekSchedule];
}

- (void)requestFailedWithError:(NSError *)error
{
    [self.userInterface showAlertMessageWithTitle:error.localizedDescription
                                          message:error.localizedFailureReason];
}
@end
