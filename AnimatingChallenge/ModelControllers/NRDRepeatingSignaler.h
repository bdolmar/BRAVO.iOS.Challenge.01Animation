//
//  NRDRepeatingSignaler.h
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/17/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NRDRepeatingSignaler : NSObject

/**
 The initial frequency of the repeating timer.
 */
@property (nonatomic, readonly) NSNumber *initialFrequency;

/**
 The normalized acceleration per minute for the repeating timer.
 1 indicates no acceleration, 2 indicates indicates the frequency will
 double after one minute, and so on.
 */
@property (nonatomic, readonly) NSNumber *accelerationFactor;

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
 Stops the repeating timer, if running.
 */
- (void)stop;

@end
