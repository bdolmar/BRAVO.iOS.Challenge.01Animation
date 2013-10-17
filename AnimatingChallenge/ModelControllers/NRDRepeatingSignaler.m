//
//  NRDRepeatingSignaler.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/17/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDRepeatingSignaler.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRDRepeatingSignaler ()

@property (nonatomic, strong) NSNumber *initialFrequency;
@property (nonatomic, strong) NSNumber *accelerationFactor;

/**
 The current frequency of the repeating timer.
 */
@property (nonatomic, strong) NSNumber *frequency;

/**
 Create a repeating timer.
 @param frequency The timer's frequency.
 @param accelerationFactor The acceleration factor per minute.
 @return The instance.
 */
- (instancetype)initWithWithInitialFrequency:(NSNumber *)frequency accelerationFactor:(NSNumber *)accelerationFactor;

- (RACSignal *)start;

@end

@implementation NRDRepeatingSignaler

+ (RACSignal *)repeatingSignalWithInitialFrequency:(NSNumber *)frequency accelerationFactor:(NSNumber *)accelerationFactor
{
    NRDRepeatingSignaler *signaler = [[self alloc] initWithWithInitialFrequency:frequency accelerationFactor:accelerationFactor];
    return [signaler start];
}

- (instancetype)initWithWithInitialFrequency:(NSNumber *)frequency accelerationFactor:(NSNumber *)accelerationFactor
{
    if ((self = [super init])) {
        self.initialFrequency = frequency;
        self.frequency = self.initialFrequency;
        self.accelerationFactor = accelerationFactor;
    }
    
    return self;
}

- (RACSignal *)start
{
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        double delayInSeconds = 0;
        __block BOOL shouldStop = NO;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            CFAbsoluteTime prevTime = startTime;
            while (!shouldStop) {
                CFAbsoluteTime newTime = CFAbsoluteTimeGetCurrent();
                CFAbsoluteTime interval = newTime - prevTime;
                if (interval > 1 / self.frequency.floatValue) {
                    prevTime = newTime;
                    
                    [subscriber sendNext:[NSDate date]];
                }
                
                // FIXME: acceleration
//                self.frequency = @(self.frequency.doubleValue + self.initialFrequency.doubleValue * interval * (self.accelerationFactor.doubleValue - 1) / 60);
            }
        });
        
        return [RACDisposable disposableWithBlock:^{
            shouldStop = YES;
        }];
    }];
}

@end
