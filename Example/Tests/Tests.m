//
//  MVGCDTimerTests.m
//  MVGCDTimerTests
//
//  Created by maximv88 on 12/21/2017.
//  Copyright (c) 2017 maximv88. All rights reserved.
//

#import "MVGCDTimer.h"
@import XCTest;

@interface Tests : XCTestCase

@end

@implementation Tests

-(void)testTimerStart {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should fire only once"];
    MVGCDTimer *timer = [MVGCDTimer timerWithTimeInterval:1 repeats:NO queue:nil block:^(MVGCDTimer *timer) {
        [expectation fulfill];
    }];
    [timer start];
    
    [self waitForExpectations:@[expectation] timeout:3];
}

-(void)testTimerStop {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should fire only once"];
    MVGCDTimer *timer = [MVGCDTimer timerWithTimeInterval:1 repeats:YES queue:nil block:^(MVGCDTimer *timer) {
        [expectation fulfill];
        [timer stop];
    }];
    [timer start];
    
    [self waitForExpectations:@[expectation] timeout:3];
}

-(void)testTimerScheduledStart {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should fire only once"];
    [MVGCDTimer scheduledTimerWithTimeInterval:1 repeats:NO queue:nil block:^(MVGCDTimer *timer) {
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:3];
}

-(void)testTimerReplacementBlock {
    XCTestExpectation *firstExpectation = [self expectationWithDescription:@"first block"];
    XCTestExpectation *secondExpectation = [self expectationWithDescription:@"second block"];
    [MVGCDTimer scheduledTimerWithTimeInterval:1 repeats:YES queue:nil block:^(MVGCDTimer *timer) {
        [firstExpectation fulfill];
        
        timer.block = ^(MVGCDTimer *timer) {
            [secondExpectation fulfill];
            [timer stop];
        };
    }];
    
    [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:3];
}

-(void)testTimerStartAfterStop {
    XCTestExpectation *firstExpectation = [self expectationWithDescription:@"first block"];
    XCTestExpectation *secondExpectation = [self expectationWithDescription:@"second block"];
    [MVGCDTimer scheduledTimerWithTimeInterval:1 repeats:YES queue:nil block:^(MVGCDTimer *timer) {
        [firstExpectation fulfill];
        [timer stop];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            timer.block = ^(MVGCDTimer *timer) {
                [secondExpectation fulfill];
                [timer stop];
            };
            
            [timer restart];
            
        });
    }];
    
    [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:6];
}

-(void)testTimerRestartForDifferentParameters {
    XCTestExpectation *firstExpectation = [self expectationWithDescription:@"first block"];
    XCTestExpectation *secondExpectation = [self expectationWithDescription:@"second block"];
    [MVGCDTimer scheduledTimerWithTimeInterval:1 repeats:YES queue:nil block:^(MVGCDTimer *timer) {
        [firstExpectation fulfill];
        [timer stop];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            timer.block = ^(MVGCDTimer *timer) {
                [secondExpectation fulfill];
                [timer stop];
            };
            
            [timer restartWithTimeInterval:2 repeats:NO];
            
        });
    }];
    
    [self waitForExpectations:@[firstExpectation, secondExpectation] timeout:6];
}

-(void)testTimerRestart {
    XCTestExpectation *expectation = [self expectationWithDescription:@"should fire only once"];
    MVGCDTimer *timer = [MVGCDTimer scheduledTimerWithTimeInterval:1 repeats:NO queue:nil block:^(MVGCDTimer *timer) {
        [expectation fulfill];
    }];
    
    [timer restartWithTimeInterval:4 repeats:NO];
    
    // test should last 4 seconds
    [self waitForExpectations:@[expectation] timeout:5];
}

@end

