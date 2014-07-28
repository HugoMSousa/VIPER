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
//  HSTraktWebServiceTests.m
//  VIPER
//
//  Created by Hugo Sousa on 22/7/14.
//

#import <XCTest/XCTest.h>

#import <OCMock.h>
#import "HSTraktWebService.h"

// Private Methods
@interface HSTraktWebService (Private)

- (void)_configureWithTraktAPIKey:(NSString *)key username:(NSString *)username;
- (NSString *)_stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
- (NSString *)_buildPathComponentStringWithPath:(NSString *)path
                                    traktAPIKey:(NSString *)traktAPIKey
                                       username:(NSString *)username
                                           date:(NSDate *)date
                                   numberOfdays:(NSNumber *)numberOfDays;

- (void (^)(NSURLSessionDataTask *, id))_executeOnGetShowsSuccess:(GetTVShowEpisodesCompletionHandler)completionHandler;
- (void (^)(NSURLSessionDataTask *, NSError *))_executeOnGetShowsFailure:(GetTVShowEpisodesCompletionHandler)completionHandler;

@end


@interface HSTraktWebServiceTests : XCTestCase
// (Object Under Test)
@property (nonatomic, strong) HSTraktWebService *SUT;
@end

@implementation HSTraktWebServiceTests

- (void)setUp
{
    [super setUp];
    
    self.SUT = [[HSTraktWebService alloc] initWithBaseURL:nil traktAPIKey:nil username:nil];
}

- (void)tearDown
{
    self.SUT = nil;
    
    [super tearDown];
}

- (void)testShouldFailForNilInstanciation
{
    XCTAssertNotNil(self.SUT, @"HSTraktWebService initializer must return a non nil instance");
}

- (void)testShouldFailForNoInternalConfigurationOnInitCall
{
    id mock = [OCMockObject partialMockForObject:self.SUT];
    [[mock expect] _configureWithTraktAPIKey:nil username:nil];
    
    id __unused initedMock = [mock initWithBaseURL:nil traktAPIKey:nil username:nil];
    [mock verify];
}

- (void)testShouldFailForInvalidDateFormat
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    NSString *dateFormat = @"yyyyMMdd";
    formatter.dateFormat = dateFormat;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *expectedStringDate = [formatter stringFromDate:date];
    
    NSString * result = [self.SUT _stringFromDate:date dateFormat:dateFormat];
    
    XCTAssertEqualObjects(result,expectedStringDate,
                          @"Date format should be:'[yyyyMMdd]'");
}

- (void)testShouldFailForInvalidStringPathFormat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *expectedStringPath = @"path/1/2/19700101/3";
    NSString *result = [self.SUT _buildPathComponentStringWithPath:@"path"
                                                                traktAPIKey:@"1"
                                                                   username:@"2"
                                                                       date:date
                                                               numberOfdays:@3];
    XCTAssertEqualObjects(result,expectedStringPath,
                          @"String Path format should be:'[path]/[traktAPIKey]/[username]/[date]/[numberOfDays]'");
}

- (void)testShouldFailForUnexpectedBehaviourOnGETShowsMethod
{
    id mock = [OCMockObject partialMockForObject:self.SUT];
   
    // Stub Block Values
    id blockSuccess = ^(NSURLSessionDataTask *task, id response){};
    id blockFailure = ^(NSURLSessionDataTask *task, NSError *error){};
    
    void (^invocation_block_success)(NSInvocation *) = ^(NSInvocation *invocation){
        [invocation setReturnValue:(__bridge void *)(blockSuccess)];
    };
    void (^invocation_block_failure)(NSInvocation *) = ^(NSInvocation *invocation){
        [invocation setReturnValue:(__bridge void *)(blockFailure)];
    };
    
    //
    // Bug Resolution :http://www.enigmaticape.com/blog/solved-returning-block-ocmock-stub
    // This way fails : [[[mock stub] andReturn:blockSuccess] _executeOnGetShowsSuccess:nil];
    
    [[[mock stub] andDo:invocation_block_success] _executeOnGetShowsSuccess:nil];
    [[[mock stub] andDo:invocation_block_failure] _executeOnGetShowsFailure:nil];
    
    [[[mock expect] andReturn:@"path/1/2/19700101/3"]
        _buildPathComponentStringWithPath:[OCMArg any]
                              traktAPIKey:[OCMArg any]
                                 username:[OCMArg any]
                                     date:[OCMArg any]
                             numberOfdays:[OCMArg any]];
    
    [[mock expect] GET:@"path/1/2/19700101/3" parameters:nil
               success:[mock _executeOnGetShowsSuccess:nil]
               failure:[mock _executeOnGetShowsFailure:nil]];
    
    // Verify
    [mock getTVShowEpisodesStartingAtDate:[NSDate date] numberOfDays:@3 completionHandler:nil];
    [mock verify];
}

- (void)testShouldFailForInvalidParamsOnSuccessBlock
{
    id mock = [OCMockObject partialMockForObject:self.SUT];
    NSURLSessionDataTask *task = [NSURLSessionDataTask new];
    
    void (^testBlock)(NSURLSessionDataTask *, id) = [mock _executeOnGetShowsSuccess:^(NSURLResponse *task, NSArray *shows, NSError *error) {
        XCTAssertTrue([shows count] == 0, @"Should have a empty results array. Input data was invalid");
        XCTAssertTrue(error == nil, @"Should not have an error");
    }];
    
    testBlock(task,@[@1,@2,@3]);
}

- (void)testShouldFailForInvalidParamsOnFailureBlock
{
    id mock = [OCMockObject partialMockForObject:self.SUT];
    NSURLSessionDataTask *task = [NSURLSessionDataTask new];
    NSError *expectedError = [NSError errorWithDomain:@"TestDomain" code:0 userInfo:nil];
    
    void (^testBlock)(NSURLSessionDataTask *, NSError *) = [mock _executeOnGetShowsFailure:^(NSURLResponse *task, NSArray *shows, NSError *error) {
        XCTAssertTrue(error != nil, @"Should have an error");
    }];
    
    testBlock(task,expectedError);
}
/*
- (void)testShouldFail
{
    id mock = [OCMockObject mockForClass:[HSTraktWebService class]];
    NSURLSessionDataTask *sessionDataTask = [NSURLSessionDataTask new];
    
    [[[mock stub] andDo:^(NSInvocation *invocation) {
        // stubbed results
        NSArray *shows = @[@1,@2,@3];//[self stubResults];
        // declare a block with same signature
        void (^callbackStubResponse)(NSURLSessionDataTask *task, NSArray *shows, NSError *error);
        // link argument 3 with our block callback
        [invocation getArgument:&callbackStubResponse atIndex:5];
        // invoke block with pre-defined input
        callbackStubResponse(sessionDataTask,shows,nil);
        
    }] getShowsForDate:[OCMArg any] username:[OCMArg any] numberOfDays:[OCMArg any] callback:[OCMArg any]];
    
    [mock getShowsForDate:[OCMArg any] username:[OCMArg any] numberOfDays:[OCMArg any] callback:^(NSURLSessionDataTask *task, NSArray *shows, NSError *error) {
        NSLog(@"calling response block from test %@",shows);
        XCTAssertTrue([shows count] == 3, @"has results");
        XCTAssertTrue(error == nil, @"should not have an error");
    }];
}*/

@end
