//
//  NRDCounter.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCounter.h"
#import <CoreGraphics/CoreGraphics.h>

#import "NRDRepeatingSignaler.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRDCounter ()

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;
@property (nonatomic, strong) NSNumber *duration;

/**
 Dispose to stop counting, if counting.
 */
@property (nonatomic, strong) RACDisposable *countingDisposable;

/**
 The timer that controls when counting occurs.
 */
@property (nonatomic, strong) NRDRepeatingSignaler *signaler;

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

        __block NSUInteger prevCount = startValue;
        
        self.signaler = [[NRDRepeatingSignaler alloc] initWithWithInitialFrequency:@((1 / intervalPerTick)) accelerationFactor:@1];
        self.countingDisposable = [[[[self.signaler start] map:^(NSDate *date) {
            NSUInteger count = prevCount + sign;
            prevCount = count;
            
            return @(count);
        }] doNext:^(NSNumber *count) {
            if ((sign == 1) ? (count.doubleValue > endValue) : (count.doubleValue < endValue)) {
                [subscriber sendCompleted];
                
                [self.countingDisposable dispose];
                self.countingDisposable = nil;
                
                [self.signaler stop];
                self.signaler = nil;
            }
        }] subscribe:subscriber];
        
        return self.countingDisposable;
    }];
}

- (CGFloat)timeIntervalPerTick
{
    return self.duration.doubleValue / abs(self.start.doubleValue - self.end.doubleValue);
}

@end
