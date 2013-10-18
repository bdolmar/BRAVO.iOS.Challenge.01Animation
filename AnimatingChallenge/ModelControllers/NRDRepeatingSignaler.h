//
//  NRDRepeatingSignaler.h
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/17/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <easing.h>

@class RACSignal;

@interface NRDRepeatingSignaler : NSObject

/**
 The initial frequency of the repeating timer.
 */
@property (nonatomic, readonly) NSNumber *initialFrequency;

/**
 The easing function, controlling how the frequency changes over time.
 */
@property (nonatomic, readonly) AHEasingFunction easingFunction;

/**
 Create a repeating timer.
 @param frequency The timer's frequency.
 @param easingFunction The easing function, controlling how the frequency changes over time.
 @return The instance.
 */
- (instancetype)initWithWithInitialFrequency:(NSNumber *)frequency easingFunction:(AHEasingFunction)easingFunction;

/**
 Start the repeating timer.
 @return A signal of dates, timed per the initial frequency and acceleration factor.
 */
- (RACSignal *)start;

/**
 Stops the repeating timer, if running.
 */
- (void)stop;

@end
