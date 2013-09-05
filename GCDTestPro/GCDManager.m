//
//  GCDManager.m
//  GCDTestPro
//
//  Created by Static Ga on 13-9-3.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import "GCDManager.h"

@interface GCDManager ()
{
    BOOL isCanceled;
    dispatch_queue_t myQueue;
}
@end

@implementation GCDManager

- (void) cancelCurrentGCD {
    isCanceled = YES;
}

- (id)init {
    if (self = [super init]) {
        isCanceled = NO;
        myQueue = dispatch_queue_create("com.GCDTestPro.myQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)doSomeWorkOnGCD {
    dispatch_async(myQueue, ^{
        for (int i = 0; i < 1000; ++i) {
            if (!isCanceled) {
                NSLog(@"i %d",i);
            }
        }
    });
}

- (void)dealloc {
    dispatch_release(myQueue);
    [super dealloc];
}
@end
