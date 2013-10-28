//
//  NRDValueAnimator.m
//  ArbitraryAnimation
//
//  Created by Ben Dolmar on 9/2/13.
//  Copyright (c) 2013 Ben Dolmar. All rights reserved.
//

#import "NRDValueAnimator.h"
#import <CoreText/CoreText.h>

@interface NRDValueAnimator ()

@property (assign, nonatomic, readwrite) NRDValueAnimatorState state;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) CGFloat change;
@property (assign, nonatomic) CFTimeInterval startTime;
@property (copy, nonatomic) NRDValueAnimatorUpdateBlock update;
@property (copy, nonatomic) NRDValueAnimatorCompletionBlock completion;
@property (assign, nonatomic) AHEasingFunction easingFunction;

@end

@implementation NRDValueAnimator

+ (AHEasingFunction)easingFunctionForEquation:(NRDEasingEquations)easingEquation
{
    switch (easingEquation) {
        case NRDEaseLinearInterpolation: return LinearInterpolation;
        case NRDEaseQuadraticIn: return QuadraticEaseIn;
        case NRDEaseQuadraticOut: return QuadraticEaseOut;
        case NRDEaseQuadraticInOut: return QuadraticEaseInOut;
        case NRDEaseCubicIn: return CubicEaseIn;
        case NRDEaseCubicOut: return CubicEaseOut;
        case NRDEaseCubicInOut: return CubicEaseInOut;
        case NRDEaseQuarticIn: return QuarticEaseIn;
        case NRDEaseQuarticOut: return QuarticEaseOut;
        case NRDEaseQuarticInOut: return QuarticEaseInOut;
        case NRDEaseQuinticIn: return QuinticEaseIn;
        case NRDEaseQuinticOut: return QuinticEaseOut;
        case NRDEaseQuinticInOut: return QuinticEaseInOut;
        case NRDEaseSineIn: return SineEaseIn;
        case NRDEaseSineOut: return SineEaseOut;
        case NRDEaseSineInOut: return SineEaseInOut;
        case NRDEaseCircularIn: return CircularEaseIn;
        case NRDEaseCircularOut: return CircularEaseOut;
        case NRDEaseCircularInOut: return CircularEaseInOut;
        case NRDEaseExponentialIn: return ExponentialEaseIn;
        case NRDEaseExponentialOut: return ExponentialEaseOut;
        case NRDEaseExponentialInOut: return ExponentialEaseInOut;
        case NRDEaseElasticIn: return ElasticEaseIn;
        case NRDEaseElasticOut: return ElasticEaseOut;
        case NRDEaseElasticInOut: return ElasticEaseInOut;
        case NRDEaseBackIn: return BackEaseIn;
        case NRDEaseBackOut: return BackEaseOut;
        case NRDEaseBackInOut: return BackEaseInOut;
        case NRDEaseBounceIn: return BounceEaseIn;
        case NRDEaseBounceOut: return BounceEaseOut;
        case NRDEaseBounceInOut: return BounceEaseInOut;
    }
}

#pragma mark - Initializers
-(instancetype)initWithStartValue:(NSNumber *)startValue endValue:(NSNumber *)endValue duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        _startValue = startValue;
        _endValue = endValue;
        _duration = duration;
        _easingEquation = NRDEaseCubicInOut;
    }
    return self;
}

-(instancetype)init
{
    return [self initWithStartValue:@0.0 endValue:@1.0 duration:1.0];
}

#pragma mark - Animation Controls
- (void)startAnimationUpdate:(NRDValueAnimatorUpdateBlock)update completion:(NRDValueAnimatorCompletionBlock)completion
{
    NSAssert(self.state == NRDValueAnimatorReady, @"The animator is already running an animation. Cancel the existing animation or wait until the current animation has completed before firing startAnimation:completion:");

    self.update = update;
    self.completion = completion;
    self.change = [self.endValue floatValue] - [self.startValue floatValue];
    self.state = NRDValueAnimatorBegan;
    self.easingFunction = [NRDValueAnimator easingFunctionForEquation:self.easingEquation];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateStepFired:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)cancelAnimation
{
    [self completeAnimation:NO];
}

#pragma mark - Animation Step Methods
- (void)updateStepFired:(CADisplayLink *)displayLink
{
    if (self.state == NRDValueAnimatorBegan) {
        self.startTime = displayLink.timestamp;
        self.update(self.startValue, self.state);
        self.state = NRDValueAnimatorChanged;
        return;
    }
    
    CFTimeInterval elapsedTime = fmin(displayLink.timestamp - self.startTime, self.duration);
    CGFloat updatePercentage = self.easingFunction(elapsedTime/self.duration);
    CGFloat updatedValue = updatePercentage*self.change + [self.startValue floatValue];
    
    self.update(@(updatedValue), self.state);
        
    if (elapsedTime >= self.duration) {
        [self completeAnimation:YES];
    }
}

- (void)completeAnimation:(BOOL)finished
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.state = finished ? NRDValueAnimatorEnded : NRDValueAnimatorCancelled;
    
    if (self.completion) {
        self.completion(finished);
    }
    
    self.state = NRDValueAnimatorReady;    
}


#pragma mark - Accessor Overrides



@end
