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
//  HSTVShowEpisodesViewCell.m
//  VIPER
//
//  Created by Hugo Sousa on 27/7/14.
//

#import "HSTVShowEpisodesViewCell.h"

#import "HSTVShowEpisodeView.h"
//#import "HSDisplayTVShowEpisode.h"
#import "HSTVShowEpisode.h"
#import "UIImageView+AFNetworking.h"

@interface HSTVShowEpisodesViewCell ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollContainer;
@property (nonatomic, weak) IBOutlet UILabel *dayLabel;

@end

@implementation HSTVShowEpisodesViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dayLabel.text = @"";
}

- (void)setUpCurrentDayString:(NSString *)currentDayString
{
    self.dayLabel.text = currentDayString;
}

- (void)setUpTVShowEpisodesWithArray:(NSArray *)episodeArray
{
    [self _removeSubviewsFromView:self.scrollContainer];
    [self _buildEpisodeViewsInScrollContainer:self.scrollContainer
                                 episodeArray:episodeArray];
    [self _recalculateScrollContainerContentSizeWithItemsNumber:episodeArray.count];
}

#pragma mark - Private Methods
- (void)_removeSubviewsFromView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)_buildEpisodeViewsInScrollContainer:(UIScrollView *)scrollContainer
                               episodeArray:(NSArray *)episodeArray
{
    
    for (int i = 0; i < episodeArray.count; i++) {
        HSTVShowEpisode *displayEpisodeInfo = episodeArray[i];
        
        CGRect frame;
        frame.origin.x = self.scrollContainer.bounds.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollContainer.bounds.size;
        
         HSTVShowEpisodeView *episode = [[HSTVShowEpisodeView alloc] initWithFrame:frame];
        
        episode.tvShowNameLabel.text = displayEpisodeInfo.showName;
        episode.episodeLabel.text = [NSString stringWithFormat:@"S%@E%@",displayEpisodeInfo.seasonNumber,displayEpisodeInfo.episodeNumber];
        episode.airTimeLabel.text = displayEpisodeInfo.airTime;
        
        NSURL *url = [NSURL URLWithString:displayEpisodeInfo.imageUrlString];
        [episode.imageView setImageWithURL:url];
        
        [self.scrollContainer addSubview:episode];
    }
}

- (void)_recalculateScrollContainerContentSizeWithItemsNumber:(NSUInteger)itemsNumber
{
    self.scrollContainer.contentSize =
        CGSizeMake(self.scrollContainer.bounds.size.width * itemsNumber,
                   self.scrollContainer.bounds.size.height);
}
@end
