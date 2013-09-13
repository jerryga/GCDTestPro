//
//  GCDTool.m
//  GCDTestPro
//
//  Created by Static Ga on 13-8-30.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import "GCDTool.h"

@interface GCDTool ()
{
    NSSet *runLoopModes;
    dispatch_queue_t myQueue;
    BOOL isValid;
}
@end

@implementation GCDTool
- (id)init {
    if (self = [super init]) {
        isValid = YES;
        myQueue = dispatch_queue_create("com.Test.MyQueue", DISPATCH_QUEUE_CONCURRENT);

    }
    
    return self;
}
//使用GCD读取文件
+ (void)readFileByGCD {
    const char* fileName = [[[NSBundle mainBundle] pathForResource:@"Test" ofType:@"txt"] UTF8String];
    int fd = open(fileName, O_NONBLOCK|O_RDONLY);    //设置type为读取
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, dispatch_get_main_queue());
    
    dispatch_source_set_event_handler(source, ^{
        //每次读取的buffer
        char buffer[1024];
        //余下的size
        size_t estimatedLength = dispatch_source_get_data(source);
        //读取size
        ssize_t bytesRead = read(fd, buffer, MIN(1024, estimatedLength));
        if (bytesRead < 0) {
            if (errno != EAGAIN) {
                printf("Unexpected error!");
                abort();
            }
        } else if (bytesRead > 0) {
            printf("Got %ld bytes of data.%ld\n", bytesRead,estimatedLength);
        } else {
            printf("EOF encountered!\n");
            dispatch_source_cancel(source);
        }
    });
    
    dispatch_source_set_cancel_handler(source, ^{
        printf("Cancel handler was called.\n");
        close(fd);
        dispatch_release(source);
    });
    
    dispatch_resume(source);
}

//测试自定义队列 两种方式：FIFO、异步
+ (void)testCustomQueueFIFO {
    //DISPATCH_QUEUE_SERIAL FIFO
    dispatch_queue_t serialQueue = dispatch_queue_create("com.Test.gcd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Task1*** ");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"Task2***");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"Task3*** ");
    });
}

+ (void)testCustomQueueAsy {
    //DISPATCH_QUEUE_CONCURRENT
    dispatch_queue_t asyQueue = dispatch_queue_create("com.Test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(asyQueue, ^{
        NSLog(@"Task1*** ");
    });
    dispatch_async(asyQueue, ^{
        NSLog(@"Task2***");
    });
    
    dispatch_async(asyQueue, ^{
        NSLog(@"Task3*** ");
    });
}

+ (void)testSyncCustomQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.Test.gcd", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"***isMainThread %d",[NSThread isMainThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"===isMainThread %d",[NSThread isMainThread]);
    });
    
    NSLog(@"This is Main");
    
}

+ (void)testGCDGroup {
    dispatch_group_t group = dispatch_group_create();

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 3");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 4");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 5");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 6");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 7");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"This is Task 8");
    });
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All task in queue finished");
    });
    NSLog(@"I am out of group");
}

+ (void)testApply {
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; ++i) {
        [testArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    int count = [testArray count];
    
    __block int sum = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_apply(count, queue, ^(size_t i) {
            sum += [[testArray objectAtIndex:i] integerValue];
            NSLog(@"sum is %d",sum);
        });
    });
    
    NSLog(@"I am out of apply");
     /*
    int sum = 0;
    for (int i = 0; i < count; ++i) {
        sum += [[testArray objectAtIndex:i] integerValue];
        NSLog(@"sum is %d",sum);
    }
    NSLog(@"I am out of for loop");
      */
//561 153
    //223 823 
}

+ (void)testThreadCount {
#if 0
    dispatch_queue_t asyQueue1 = dispatch_queue_create("com.Test.gcd001", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue2 = dispatch_queue_create("com.Test.gcd002", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue3 = dispatch_queue_create("com.Test.gcd003", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue4 = dispatch_queue_create("com.Test.gcd004", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue5 = dispatch_queue_create("com.Test.gcd005", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue6 = dispatch_queue_create("com.Test.gcd006", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue7 = dispatch_queue_create("com.Test.gcd007", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue8 = dispatch_queue_create("com.Test.gcd008", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue9 = dispatch_queue_create("com.Test.gcd009", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t asyQueue10 = dispatch_queue_create("com.Test.gcd0010", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    });
    
    dispatch_async(asyQueue2, ^{
        NSLog(@"queue2 %@",[NSThread currentThread]);
    });
    
    dispatch_async(asyQueue3, ^{
        NSLog(@"queue3 %@",[NSThread currentThread]);
    });
    
    dispatch_async(asyQueue4, ^{
        NSLog(@"queue4 %@",[NSThread currentThread]);
    });
    
    dispatch_async(asyQueue5, ^{
        NSLog(@"queue5 %@",[NSThread currentThread]);
    });
    dispatch_async(asyQueue6, ^{
        NSLog(@"queue6 %@",[NSThread currentThread]);
    });
    dispatch_async(asyQueue7, ^{
        NSLog(@"queue7 %@",[NSThread currentThread]);
    });dispatch_async(asyQueue8, ^{
        NSLog(@"queue8 %@",[NSThread currentThread]);
    });dispatch_async(asyQueue9, ^{
        NSLog(@"queue9 %@",[NSThread currentThread]);
    });dispatch_async(asyQueue10, ^{
        NSLog(@"queue10 %@",[NSThread currentThread]);
    });
#endif
    dispatch_queue_t asyQueue1 = dispatch_queue_create("com.Test.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    }); dispatch_async(asyQueue1, ^{
        NSLog(@"queue1 %@",[NSThread currentThread]);
    });
}

- (NSSet *) getRunModes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    });
    return runLoopModes;
}

+ (void)testRunLoop {
    GCDTool *tool = [[GCDTool alloc] init];
    [self performSelector:@selector(cancelConnection) onThread:[GCDTool getTestThread] withObject:nil waitUntilDone:YES modes:[[tool getRunModes] allObjects]];

}

+ (NSThread *)getTestThread {
    NSThread *networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
    [networkRequestThread start];
    return networkRequestThread;
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"GCDToolTesting"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
        NSLog(@"running %@",runLoop.currentMode);
    }
}

+ (void)cancelConnection {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSLog(@"running %@",runLoop.currentMode);

    NSLog(@"testConnection %d",[NSThread isMainThread]);
}
@end





















