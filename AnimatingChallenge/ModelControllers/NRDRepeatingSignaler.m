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

/**
 A signal on which the date will be sent at the timer's frequency.
 */
@property (nonatomic, strong) RACSignal *timingSignal;

/**
 The frequency of the repeating timer.
 */
@property (nonatomic, strong) NSNumber *frequency;

@end

@implementation NRDRepeatingSignaler

+ (instancetype)repeatingSignalerWithWithInitialFrequency:(NSNumber *)frequency
{
    NRDRepeatingSignaler *signaler = [[NRDRepeatingSignaler alloc] init];
    signaler.frequency = frequency;
    
    return signaler;
}

- (RACSignal *)timingSignal
{
    NSTimeInterval interval = 1 / self.frequency.doubleValue;
    return [RACSignal interval:interval onScheduler:[RACScheduler scheduler]];
}

@end
