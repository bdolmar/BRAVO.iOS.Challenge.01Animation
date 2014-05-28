//
//  NRDIntegerTweenerLayer.m
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDIntegerTweenerLayer.h"

@interface NRDIntegerTweenerLayer ()

@property (assign, nonatomic) NSInteger intValue;

@end

@implementation NRDIntegerTweenerLayer

@dynamic intValue;

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer]) {
        NRDIntegerTweenerLayer *other = (NRDIntegerTweenerLayer *)layer;
        self.intValue = other.intValue;
        self.tweeningDelegate = other.tweeningDelegate;
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return ([key isEqualToString:@"intValue"] || [super needsDisplayForKey:key]);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    [super drawLayer:layer inContext:ctx];
    
    [self.tweeningDelegate onValueChanged:self.intValue];
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    [self.tweeningDelegate onValueChanged:self.intValue];
}

- (void)animateFrom:(NSInteger)fromValue to:(NSInteger)toValue duration:(CFTimeInterval)animationDuration style:(TweeningAnimationStyle)animationStyle
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"intValue"];
    animation.fromValue = [NSNumber numberWithInt:fromValue];
    animation.toValue = [NSNumber numberWithInt:toValue];
    animation.timingFunction = [self mediaTimingFunctionForTweeningAnimationStyle:animationStyle];
    animation.duration = animationDuration;
    animation.delegate = nil;

    [self addAnimation:animation forKey:@"intValueAnimation"];
    
    self.intValue = toValue;
}

- (void)cancelAnimation
{
    [self removeAnimationForKey:@"intValueAnimation"];
}

- (CAMediaTimingFunction *)mediaTimingFunctionForTweeningAnimationStyle:(TweeningAnimationStyle)animationStyle
{
    switch (animationStyle) {
        case TweeningAnimationStyleDefault:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        case TweeningAnimationStyleEaseIn:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        case TweeningAnimationStyleEaseInEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        case TweeningAnimationStyleEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        case TweeningAnimationStyleLinear:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        default:
            return nil;
    }
}

@end
