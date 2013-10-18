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
 The subject on which signals will be sent when firing.
 */
@property (nonatomic, strong) RACSubject *signalingSubject;

/**
 The timer itself.
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 Internal flag to indicate that the timer should stop.
 */
@property (nonatomic) BOOL shouldStop;

/**
 The current frequency of the repeating timer.
 */
@property (nonatomic, strong) NSNumber *frequency;

/**
 Callback for the repeating timer. When fired, sends the current date on signalingSubject.
 @param timer The timer firing.
 @return A signal of dates, timed per the initial frequency and acceleration factor.
 */
- (void)timerCallback:(NSTimer *)timer;

@end

@implementation NRDRepeatingSignaler

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
    self.signalingSubject = [RACSubject subject];
    
    CGFloat frequency = self.frequency.doubleValue;
    NSTimeInterval interval = (1 / frequency);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(timerCallback:)
                                                userInfo:nil
                                                 repeats:NO];
    return self.signalingSubject;
}

- (void)timerCallback:(NSTimer *)timer
{
    if (self.shouldStop) {
        self.shouldStop = NO;
        return;
    }
    
    CGFloat originalFreq = self.frequency.doubleValue;
    NSTimeInterval originalInterval = (1 / originalFreq);
    self.frequency = @(originalFreq + (originalInterval * ((self.accelerationFactor.doubleValue - 1) / 60)));
    
    [self.signalingSubject sendNext:[NSDate date]];
    
    CGFloat frequency = self.frequency.doubleValue;
    NSTimeInterval interval = (1 / frequency);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerCallback:) userInfo:nil repeats:NO];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.shouldStop = YES;
}

@end
