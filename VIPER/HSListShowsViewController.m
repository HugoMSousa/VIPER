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
//  HSListShowsViewController.m
//  VIPER
//
//  Created by Hugo Sousa on 27/7/14.
//

#import "HSListShowsViewController.h"

#import "HSListShowsModuleInterface.h"
#import "HSTVShowEpisodesViewCell.h"

#import "HSTVShowDaySchedule.h"
#import "HSTVShowEpisode.h"

@interface HSListShowsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *displayDataSource;

@end

@implementation HSListShowsViewController

- (void)dealloc
{
    self.displayDataSource = nil;
}

- (instancetype)init
{
    self = [super initWithNibName:SCREEN_LIST_SHOWS bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayDataSource = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self _registerTVShowEpisodesViewCellIdentifierInTableView];
    
    [self.eventHandler updateListWithCurrentWeekItems];
}

#pragma mark - TableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSTVShowEpisodesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID_TVSHOW_EPISODES forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(HSTVShowEpisodesViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSTVShowDaySchedule *daySchedule = self.displayDataSource[indexPath.row];
    
    [cell setUpCurrentDayString:daySchedule.date];
    [cell setUpTVShowEpisodesWithArray:daySchedule.tvShowEpisodes];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayDataSource.count;
}

#pragma mark - TableView Delegate

#pragma mark - View Interface

- (void)insertNextWeekSchedule:(NSArray *)weekSchedule
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, weekSchedule.count)];
    [self.displayDataSource insertObjects:weekSchedule atIndexes:indexSet];
    [self.tableView reloadData];
}

- (void)insertPreviousWeekSchedule:(NSArray *)weekSchedule
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_displayDataSource.count - 1, weekSchedule.count)];
    [self.displayDataSource insertObjects:weekSchedule atIndexes:indexSet];
    [self.tableView reloadData];
}

- (void)showAlertMessageWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Private Methods
- (void)_registerTVShowEpisodesViewCellIdentifierInTableView
{
    UINib *cellNib = [UINib nibWithNibName:CELL_ID_TVSHOW_EPISODES bundle:[NSBundle bundleForClass:[HSTVShowEpisodesViewCell class]]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:CELL_ID_TVSHOW_EPISODES];
}
@end
