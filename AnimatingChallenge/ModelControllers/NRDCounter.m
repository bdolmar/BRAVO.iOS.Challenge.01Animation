//
//  NRDCounter.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCounter.h"

#import <CoreGraphics/CoreGraphics.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRDCounter ()

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;
@property (nonatomic, strong) NSNumber *duration;

- (CGFloat)timeIntervalPerTick;

@end

@implementation NRDCounter

- (instancetype)initWithStart:(NSNumber *)start end:(NSNumber *)end duration:(NSNumber *)duration
{
    if ((self = [super init])) {
        self.start = start;
        self.end = end;
        self.duration = duration;
    }
    
    return self;
}

- (RACSignal *)count
{
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        CGFloat intervalPerTick = [self timeIntervalPerTick];
        
        CGFloat startValue = self.start.doubleValue;
        CGFloat endValue = self.end.doubleValue;
        
        NSInteger sign = (startValue < endValue) ? 1 : -1;
        
        double delayInSeconds = 0;
        __block BOOL shouldStop = NO;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            CFAbsoluteTime prevTime = startTime;
            NSUInteger prevCount = startValue;
            while (!shouldStop) {
                CFAbsoluteTime newTime = CFAbsoluteTimeGetCurrent();
                CFAbsoluteTime interval = newTime - prevTime;
                if (interval > intervalPerTick) {
                    prevTime = newTime;
                    CGFloat ticks = interval / intervalPerTick;
                    NSUInteger count = prevCount + (sign * ticks);
                    
                    if ((sign == 1) ? (count > endValue) : (count < endValue)) {
                        count = endValue;
                    }
                    
                    [subscriber sendNext:@(count)];
                    
                    prevCount = count;
                }
                
                if ((sign == 1) ? (prevCount >= endValue) : (prevCount <= endValue)) {
                    break;
                }
            }
            
            [subscriber sendCompleted];
        });
        
        return [RACDisposable disposableWithBlock:^{
            shouldStop = YES;
        }];
    }];
}

- (CGFloat)timeIntervalPerTick
{
    return self.duration.doubleValue / abs(self.start.doubleValue - self.end.doubleValue);
}

@end
