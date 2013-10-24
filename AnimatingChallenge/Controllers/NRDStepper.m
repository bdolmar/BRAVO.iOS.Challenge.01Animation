//
//  NRDStepper.m
//  AnimatingChallenge
//
//  Created by Dan Kane on 10/18/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDStepper.h"

@interface NRDStepper ()

@property (readwrite, nonatomic) CGFloat progress;

@end

@implementation NRDStepper

- (NSTimeInterval)timeIntervalForStep:(NSUInteger)step
{
    NSAssert(0 <= step && step <= self.totalSteps, @"Fatal Error: Step is outside total range.");
    
    // Normalize step and do Bézier calculation
    CGFloat t = (CGFloat)step / self.totalSteps;
    self.progress = t;
    CGFloat equivalentSteps = [self.class normalizedBezierPointForT:t timingFunction:self.timingFunction].x;
    CGFloat result = equivalentSteps * self.totalDuration / self.totalSteps;
    NSLog(@"step: %d\twait: %f", step, result);
    return result;
}

#pragma mark - Setters

- (void)setTimerCurveType:(TimerCurveType)timerCurveType
{
    _timerCurveType = timerCurveType;
    switch (timerCurveType) {
        case TimerCurveTypeEaseOutCirc:
            self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.075 :0.82 :0.165 :1.0];
            break;
            
        case TimerCurveTypeEaseOutExp:
            self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.19 :1.0 :0.22 :1.0];
            break;
            
        case TimerCurveTypeEaseOutCubic:
            self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.215 :0.61 :0.355 :1.0];
            break;
            
        case TimerCurveTypeEaseOut:
            self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            break;
            
        case TimerCurveTypeLinear:
            self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            break;
            
        case TimerCurveTypeDefault:
            self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            break;
            
        case TimerCurveTypeConstant:
        default:
            self.timingFunction = nil;
            break;
    }
}

#pragma mark - Class methods

+ (CGPoint)normalizedBezierPointForT:(CGFloat)t timingFunction:(CAMediaTimingFunction *)timingFunction
{
    NSAssert(0 <= t && t <= 1.0, @"Fatal Error: t must be on the interval [0,1].");
    
    // Default to TimerCurveTypeConstant: B(t) = 1
    if (timingFunction == nil) {
        return CGPointMake(1.0, 1.0);
    }
    
    // Bézier funtion (cubic) B(t) = (1-t)^3 * P0  +  3(1-t)^2 * t * P1  +  3(1-t) * t^2 * P2  +  t^3 * P3
    // t is on the interval [0,1]
    // Solve for P(x,y)
    
    float p0[2], p1[2], p2[2], p3[2];
    [timingFunction getControlPointAtIndex:0 values:p0];
    [timingFunction getControlPointAtIndex:1 values:p1];
    [timingFunction getControlPointAtIndex:2 values:p2];
    [timingFunction getControlPointAtIndex:3 values:p3];
    
    CGFloat x = pow(1-t,3) * p0[0] + 3*pow(1-t,2) * t * p1[0] + 3*(1-t) * pow(t,2) * p2[0] + pow(t,3) * p3[0];
    CGFloat y = pow(1-t,3) * p0[1] + 3*pow(1-t,2) * t * p1[1] + 3*(1-t) * pow(t,2) * p2[1] + pow(t,3) * p3[1];
    
    
    // Integral from 0 to 1 of Bézier = (P0 + P1 + P2 + P3)/4
    // Use this to scale the output and normalize the number of steps
    
    CGFloat xScalar = (p0[0] + p1[0] + p2[0] + p3[0])/4;
    CGFloat yScalar = (p0[1] + p1[1] + p2[1] + p3[1])/4;
    
    return CGPointMake(x/xScalar, y/yScalar);
}

+ (NSString *)nameForCurve:(TimerCurveType)timerCurveType
{
    switch (timerCurveType) {
        case TimerCurveTypeEaseOutCirc:
            return @"Ease Out: Circular";
            break;
            
        case TimerCurveTypeEaseOutExp:
            return @"Ease Out: Exponential";
            break;
            
        case TimerCurveTypeEaseOutCubic:
            return @"Ease Out: Cubic";
            break;
            
        case TimerCurveTypeEaseOut:
            return @"Ease Out";
            break;
            
        case TimerCurveTypeLinear:
            return @"Linear";
            break;
            
        case TimerCurveTypeDefault:
            return @"Default";
            break;
            
        case TimerCurveTypeConstant:
        default:
            return @"None";
            break;
    }
}

@end
