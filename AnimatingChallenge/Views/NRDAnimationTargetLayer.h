//
//  NRDAnimationTargetLayer.h
//  AnimatingChallenge
//
//  Created by Joshua Sullivan on 10/18/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

/**
 *  This class is simply a receiver for Core Animations. It relays the value for animationProgress to its delegate.
 *  NOTE: The layer must be added to the display and have a non-zero frame to be eligible for animations.
 */

#import <QuartzCore/QuartzCore.h>

extern NSString *const kAnimationProgressKey;

@protocol AnimationTargetDelegate;

@interface NRDAnimationTargetLayer : CALayer

@property (assign, nonatomic) CGFloat animationProgress;
@property (weak, nonatomic) id <AnimationTargetDelegate> targetDelegate;

@end


@protocol AnimationTargetDelegate <NSObject>

@required
- (void)animationProgressDidChange:(CGFloat)animationProgress;

@end
