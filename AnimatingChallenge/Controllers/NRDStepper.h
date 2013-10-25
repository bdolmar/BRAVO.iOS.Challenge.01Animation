//
//  NRDStepper.h
//  AnimatingChallenge
//
//  Created by Dan Kane on 10/18/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TimerCurveType) {
    // Built-in timing functions
    TimerCurveTypeLinear,
    TimerCurveTypeEaseOut,
    TimerCurveTypeDefault,
    
    // Custom timing functions
    TimerCurveTypeEaseOutCubic,
    TimerCurveTypeEaseOutExp,
    TimerCurveTypeEaseOutCirc,
    
    // Total number of curves
    TimerCurveTypeCount
};

@interface NRDStepper : NSObject

@property (assign, nonatomic) NSUInteger totalSteps;
@property (assign, nonatomic) NSTimeInterval totalDuration;

@property (assign, nonatomic) TimerCurveType timerCurveType;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

@property (readonly, nonatomic) CGFloat progress;

- (NSTimeInterval)timeIntervalForStep:(NSUInteger)step;
- (NSUInteger)stepAtTime:(NSTimeInterval)time;

+ (CGPoint)bezierPointForT:(CGFloat)t
            timingFunction:(CAMediaTimingFunction *)timingFunction
                normalizeSum:(BOOL)normalized;
+ (NSString *)nameForCurve:(TimerCurveType)timerCurveType;

@end
