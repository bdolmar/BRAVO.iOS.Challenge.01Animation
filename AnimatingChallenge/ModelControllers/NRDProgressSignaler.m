//
//  NRDProgressSignaler.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/21/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDProgressSignaler.h"
#import <CoreGraphics/CoreGraphics.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRDProgressSignaler ()

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AHEasingFunction easingFunction;

@property (nonatomic, strong) NSDate *startingDate;

/**
 The disposable which may be used to cancel progress signaling.
 */
@property (nonatomic, strong) RACDisposable *progressDisposable;

@end

@implementation NRDProgressSignaler

+ (instancetype)progressSignalerWithDuration:(NSTimeInterval)duration easingFunction:(AHEasingFunction)easingFunction
{
    NRDProgressSignaler *signaler = [[NRDProgressSignaler alloc] init];
    signaler.duration = duration;
    signaler.easingFunction = easingFunction;
    
    return signaler;
}

- (RACSignal *)progressSignalWithTimingSignal:(RACSignal *)timingSignal
{
    if (self.progressDisposable) {
        [self.progressDisposable dispose];
        self.progressDisposable = nil;
    }
    
    self.startingDate = [NSDate date];
    
    __block BOOL shouldCancel = NO;
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.progressDisposable = [[[timingSignal doNext:^(NSDate *date) {
            if (shouldCancel) {
                [subscriber sendCompleted];
                [self.progressDisposable dispose];
            }
            
            // Cancel after at least one signal was sent after self.duration
            if ([date timeIntervalSinceDate:self.startingDate] > self.duration) {
                shouldCancel = YES;
            }
        }] map:^(NSDate *date) {
            NSTimeInterval interval = [date timeIntervalSinceDate:self.startingDate];
            
            CGFloat progressPercentage = interval / self.duration;
            CGFloat progressPercentageClamped = MIN(progressPercentage, 1.0);
            
            CGFloat easedProgress = self.easingFunction(progressPercentageClamped);
            
            return @(easedProgress);
        }] subscribe:subscriber];
        
        return self.progressDisposable;
    }];
}

@end
