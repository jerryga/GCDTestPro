//
//  GCDManager.h
//  GCDTestPro
//
//  Created by Static Ga on 13-9-3.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDManager : NSObject
- (void)doSomeWorkOnGCD;
- (void) cancelCurrentGCD;
@end
