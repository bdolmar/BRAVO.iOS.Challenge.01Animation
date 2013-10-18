//
//  NRDCounter.h
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NRDCounter : NSObject

@property (nonatomic, readonly) NSNumber *start;
@property (nonatomic, readonly) NSNumber *end;
@property (nonatomic, readonly) NSNumber *duration;

/**
 Create a counter with the given start and end counts, and a duration in seconds.
 @param start The starting number.
 @param end The ending number.
 @param duration The time, in seconds, to take counting from `start` to `end`.
 @return The instance.
 */
- (instancetype)initWithStart:(NSNumber *)start end:(NSNumber *)end duration:(NSNumber *)duration;

/**
 Count on every event from the timing signal.
 @param timingSignal The signal controlling when to count.
 @return A signal of values.
 */
- (RACSignal *)countWithTimingSignal:(RACSignal *)timingSignal;

@end
