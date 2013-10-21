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

/// A number in [0,1] indicating the progress counting from start to end.
@property (nonatomic, readonly) NSNumber *progress;

/**
 Create a counter with the given start and end counts.
 @param start The starting number.
 @param end The ending number.
 @return The instance.
 */
+ (instancetype)counterWithStart:(NSNumber *)start end:(NSNumber *)end;

/**
 Count based on the progress from the progress signal.
 @param progressSignal The signal controlling the counting progress.
 @return A signal of values.
 */
- (RACSignal *)countingSignalWithProgressSignal:(RACSignal *)progressSignal;

@end
