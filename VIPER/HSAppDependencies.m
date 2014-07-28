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
//  HSAppDependencies.m
//  VIPER
//
//  Created by Hugo Sousa on 26/7/14.
//

#import "HSAppDependencies.h"

#import "HSCoreDataStore.h"
#import "HSTraktWebService.h"
#import "HSRootWireframe.h"

#import "HSListShowsModuleInterface.h"
#import "HSListShowsDataManager.h"
#import "HSListShowsInteractor.h"
#import "HSListShowsPresenter.h"
#import "HSListShowsViewController.h"

@interface HSAppDependencies ()

@property (nonatomic, strong) HSListShowsPresenter *listShowsPresenter;

@end


@implementation HSAppDependencies

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        [self _configureModuleDependenciesInWindow:window];
    }
    return self;
}

- (void)_configureModuleDependenciesInWindow:(UIWindow *)window
{
    // Root Level Classes
    HSTraktWebService *traktWebService = [[HSTraktWebService alloc] initWithBaseURL:[NSURL URLWithString:TRAKT_BASE_URL_STRING] traktAPIKey:TRAKT_API_KEY username:TRAKT_USERNAME];
    HSCoreDataStore *coreDataStore = [[HSCoreDataStore alloc] init];
    HSRootWireframe *rootWireframe = [[HSRootWireframe alloc] initWithWindow:window];
    
    // List Shows Module Classes
    HSListShowsDataManager *listShowsDataManager = [[HSListShowsDataManager alloc] initWithDataStore:coreDataStore traktWebService:traktWebService];
    HSListShowsInteractor *listShowsInteractor = [[HSListShowsInteractor alloc] initWithDataManager:listShowsDataManager];
    HSListShowsWireframe *listShowsWireframe = [[HSListShowsWireframe alloc] initWithRootWireframe:rootWireframe];
    HSListShowsPresenter *listShowsPresenter = [[HSListShowsPresenter alloc] initWithInteractor:listShowsInteractor wireframe:listShowsWireframe];
    
    listShowsInteractor.output = listShowsPresenter;
    
    self.listShowsPresenter = listShowsPresenter;
}

- (void)installRootUserInterface
{
    HSListShowsViewController *userInterface = [self.listShowsPresenter.wireframe createNewListShowsUserInterface];
    userInterface.title = NSLocalizedString(@"TV Shows Schedule", nil);
    [self _installAsRootUserInterface:userInterface];
}

- (void)_installAsRootUserInterface:(HSListShowsViewController *)userInterface
{
     userInterface.eventHandler = self.listShowsPresenter;
     self.listShowsPresenter.userInterface = userInterface;
    
    [self.listShowsPresenter.wireframe presentAsRootUserInterface:userInterface];
}

@end
