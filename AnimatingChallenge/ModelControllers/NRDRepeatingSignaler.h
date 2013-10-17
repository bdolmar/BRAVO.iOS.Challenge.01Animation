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
@property (nonatomic, readonly) NSNumber *startingFrequency;

/**
 The normalized acceleration per minute for the repeating timer.
 1 indicates no acceleration, 2 indicates indicates the frequency will
 double after one minute.s
 */
@property (nonatomic, readonly) NSNumber *accelerationFactor;

/**
 Create a repeating timer. Stop the timer by unsubscribing to the returned signal. Note that acceleration is ignored, for now.
 @param frequency The timer's frequency.
 @param accelerationFactor The acceleration factor per minute. Ignored for now.
 @return A repeating signal.
 */
+ (RACSignal *)repeatingSignalWithInitialFrequency:(NSNumber *)frequency accelerationFactor:(NSNumber *)accelerationFactor;

@end
