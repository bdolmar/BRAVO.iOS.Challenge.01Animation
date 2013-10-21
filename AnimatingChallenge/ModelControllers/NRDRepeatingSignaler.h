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
 The frequency of the repeating timer.
 */
@property (nonatomic, readonly) NSNumber *frequency;

/**
 Create a repeating timer.
 @param frequency The timer's frequency.
 @return The instance.
 */
+ (instancetype)repeatingSignalerWithWithInitialFrequency:(NSNumber *)frequency;

/**
 Start the repeating timer.
 @return A signal of dates, timed per the initial frequency and acceleration factor.
 */
- (RACSignal *)timingSignal;

@end
