//
//  LifeInGuangZhouUITests.m
//  LifeInGuangZhouUITests
//
//  Created by Wei Sun on 2019/2/13.
//  Copyright © 2019 Wei Sun Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LifeInGuangZhouUITests-Swift.h"

@interface LifeInGuangZhouUITests : XCTestCase

@end

@implementation LifeInGuangZhouUITests

- (void)setUp {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [Snapshot snapshot:@"main" timeWaitingForIdle:10];
}

@end
