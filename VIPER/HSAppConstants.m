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
//  HSAppConstants.m
//  VIPER
//
//  Created by Hugo Sousa on 22/7/14.
//

#import "HSAppConstants.h"

// ---- TRAKT API Constants ------------------------------------------
  #ifdef DEBUG
    NSString * const TRAKT_API_KEY = @"cfa6fb6fda149d28b13f56129da0bff9";
    NSString * const TRAKT_BASE_URL_STRING = @"http://api.trakt.tv";
    NSString * const TRAKT_USERNAME = @"rwtestuser";
  #else
    NSString * const TRAKT_API_KEY = @"cfa6fb6fda149d28b13f56129da0bff9";
    NSString * const TRAKT_BASE_URL_STRING = @"http://api.trakt.tv";
    NSString * const TRAKT_USERNAME = @"rwtestuser";
  #endif


// ---- Screen Names --------------------------------------------------
NSString * const SCREEN_LIST_SHOWS = @"HSListShowsViewController";


// ---- Custom Table View Cell Identifiers ---------------------------
NSString *const CELL_ID_TVSHOW_EPISODES = @"HSTVShowEpisodesViewCell";