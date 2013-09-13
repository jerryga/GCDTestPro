//
//  GCDTool.h
//  GCDTestPro
//
//  Created by Static Ga on 13-8-30.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTool : NSObject

+ (void)readFileByGCD;
+ (void)testCustomQueueFIFO;
+ (void)testCustomQueueAsy;

+ (void)testSyncCustomQueue;

+ (void)testGCDGroup;
+ (void)testApply;

+ (void)testThreadCount;
+ (void)testRunLoop;
@end
