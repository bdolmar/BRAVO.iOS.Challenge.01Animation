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

/**
 Start the repeating timer.
 @return A signal of dates, timed per the initial frequency and acceleration factor.
 */
- (RACSignal *)start;

/**
 Create a signal for the repeating timer.
 @return A signal of dates, timed per the initial frequency and acceleration factor.
 */
- (RACSignal *)recursiveTimerSignal;

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
    return [self recursiveTimerSignal];
}

- (RACSignal *)recursiveTimerSignal
{
    CGFloat frequency = self.frequency.doubleValue;
    NSTimeInterval interval = (1 / frequency);
    
    // FIXME: acceleration
    RACSignal *timer = [[RACSignal interval:interval onScheduler:[RACScheduler scheduler]] take:1];
    
    // Repeat without immediate, infinite recursion using -[RACSignal then:]
    return [timer concat:[[RACSignal empty] then:^RACSignal *{
        return [self recursiveTimerSignal];
    }]];
}

@end
