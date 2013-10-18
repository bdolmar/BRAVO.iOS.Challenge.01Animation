//
//  NRDAnimationTargetLayer.m
//  AnimatingChallenge
//
//  Created by Joshua Sullivan on 10/18/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

NSString *const kAnimationProgressKey = @"animationProgress";

#import "NRDAnimationTargetLayer.h"

@implementation NRDAnimationTargetLayer

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        self.animationProgress = ((NRDAnimationTargetLayer *)layer).animationProgress;
        self.targetDelegate = ((NRDAnimationTargetLayer *)layer).targetDelegate;
        [self commonInit];
    }
    return self;
}

/**
 *  Make the layer invisible and off-stage.
 */
- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.frame = CGRectMake(-1.0f, -1.0f, 1.0f, 1.0f);
}

#pragma mark - Force animation for custom property

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:kAnimationProgressKey]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

#pragma mark - Getters & Setters

/**
 *  Inform delegate when the animationProgress value updates.
 */
- (void)setAnimationProgress:(CGFloat)animationProgress
{
    _animationProgress = animationProgress;
    [self.targetDelegate animationProgressDidChange:animationProgress];
}

@end
