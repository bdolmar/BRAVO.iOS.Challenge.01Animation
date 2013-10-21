//
//  NRDProgressSignaler.h
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/21/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <easing.h>

@class RACSignal;

@interface NRDProgressSignaler : NSObject

/**
 The easing function, controlling how the frequency changes over time.
 */
@property (nonatomic, readonly) AHEasingFunction easingFunction;

/**
 Create a progress signal with the specified duration and easing function.
 @param duration The duration over which the signaler will progress.
 @param easingFunction The easing function, controlling progress over time.
 @return The instance.
 */
+ (instancetype)progressSignalerWithDuration:(NSTimeInterval)duration easingFunction:(AHEasingFunction)easingFunction;

/**
 Start the progress signaler with the specified timing signal.
 @param timingSignal A signal which will trigger the sending of progress events.
 @return A progress signal controlled by the timing signal.
 */
- (RACSignal *)progressSignalWithTimingSignal:(RACSignal *)timingSignal;

@end
