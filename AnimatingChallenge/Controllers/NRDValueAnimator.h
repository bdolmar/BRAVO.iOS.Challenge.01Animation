//
//  NRDValueAnimator.h
//  ArbitraryAnimation
//
//  Created by Ben Dolmar on 9/2/13.
//  Copyright (c) 2013 Ben Dolmar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "easing.h"

typedef NS_ENUM(NSUInteger, NRDValueAnimatorState){
    NRDValueAnimatorReady,
    NRDValueAnimatorBegan,
    NRDValueAnimatorChanged,
    NRDValueAnimatorEnded,
    NRDValueAnimatorCancelled
};

typedef NS_ENUM(NSUInteger, NRDEasingEquations){
    NRDEaseLinearInterpolation,
    NRDEaseQuadraticIn,
    NRDEaseQuadraticOut,
    NRDEaseQuadraticInOut,
    NRDEaseCubicIn,
    NRDEaseCubicOut,
    NRDEaseCubicInOut,
    NRDEaseQuarticIn,
    NRDEaseQuarticOut,
    NRDEaseQuarticInOut,
    NRDEaseQuinticIn,
    NRDEaseQuinticOut,
    NRDEaseQuinticInOut,
    NRDEaseSineIn,
    NRDEaseSineOut,
    NRDEaseSineInOut,
    NRDEaseCircularIn,
    NRDEaseCircularOut,
    NRDEaseCircularInOut,
    NRDEaseExponentialIn,
    NRDEaseExponentialOut,
    NRDEaseExponentialInOut,
    NRDEaseElasticIn,
    NRDEaseElasticOut,
    NRDEaseElasticInOut,
    NRDEaseBackIn,
    NRDEaseBackOut,
    NRDEaseBackInOut,
    NRDEaseBounceIn,
    NRDEaseBounceOut,
    NRDEaseBounceInOut
};

typedef void(^NRDValueAnimatorUpdateBlock)(NSNumber *currentValue, NRDValueAnimatorState state);
typedef void(^NRDValueAnimatorCompletionBlock)(BOOL finished);

@interface NRDValueAnimator : NSObject

#pragma mark - Class Methods

+ (AHEasingFunction)easingFunctionForEquation:(NRDEasingEquations)easingEquation;

#pragma mark - Instance Properties
/**
 *  The duration of the animation in seconds. Note this value should not be changed on a running animation.
 */
@property (assign, nonatomic) NSTimeInterval duration;

/**
 *  The initial scalar value that will be tweened. Note this value should not be changed on a running animation.
 */
@property (strong, nonatomic) NSNumber *startValue;

/**
 *  The expected end-state scalar value for the tween. Note this value should not be changed on a running animation.
 */
@property (strong, nonatomic) NSNumber *endValue;

/**
 *  The easing function to be used on the tween. This is expected to be one of the standard functions 
 *  from Robert Penner's easing library.
 */
@property (assign, nonatomic) NRDEasingEquations easingEquation;

/**
 *  The current state of the animator object. During it's lifecyle the animator will flow through one 
 *  of the following two paths:
 *      NRDValueAnimatorReady --> NRDValueAnimatorBegan --> NRDValueAnimatorChanged --> NRDValueAnimatorEnded
 *  or
 *      NRDValueAnimatorReady --> NRDValueAnimatorBegan --> NRDValueAnimatorChanged --> NRDValueAnimatorCancelled
 */
@property (assign, nonatomic, readonly) NRDValueAnimatorState state;


#pragma mark - Public Methods

/**
 *  The designated initializer for the class. Creates and animator object configured with the values passed 
 *  and ready to be started.
 *
 *  @param startingValue The initial scalar value that will be tweened.
 *  @param endValue      The expected end-state scalar value for the tween.
 *  @param duration      The duration of the animation in seconds.
 *
 *  @return An initialized instance of the class
 */
- (instancetype)initWithStartValue:(NSNumber *)startValue endValue:(NSNumber *)endValue duration:(NSTimeInterval)duration;

/**
 *  Starts the animation runloop. This will trigger a state change in the animator moving it's state to NRDValueAnimatorBegan. 
 *  It is expected that the developer will implement logic in the update block to handle changes in the tweened scalar.
 *
 *  @param update     This block will be fired on every step of the tween. This is where the developer should be doing the work to update their UI.
 *  @param completion This block will be fired when the animator has completed the tween or the tween is cancelled.
 */
- (void)startAnimationUpdate:(NRDValueAnimatorUpdateBlock)update completion:(NRDValueAnimatorCompletionBlock)completion;

/**
 *  Stops the animation and removes any active running timers.
 */
- (void)cancelAnimation;

@end
