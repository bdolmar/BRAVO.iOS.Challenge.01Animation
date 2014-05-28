//
//  NRDTweeningLayer.h
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, TweeningAnimationStyle) {
    TweeningAnimationStyleDefault,
    TweeningAnimationStyleEaseIn,
    TweeningAnimationStyleEaseInEaseOut,
    TweeningAnimationStyleEaseOut,
    TweeningAnimationStyleLinear,
};

@class NRDTweeningLayer;

@protocol NRDTweeningLayerDelegate <NSObject>

- (void)onValueChanged:(NSInteger)newValue;

@end

@interface NRDTweeningLayer : CALayer

@property (weak, nonatomic) id<NRDTweeningLayerDelegate> tweeningDelegate;

- (void)animateFrom:(NSInteger)fromValue to:(NSInteger)toValue duration:(CFTimeInterval)animationDuration style:(TweeningAnimationStyle)animationStyle;
- (void)cancelAnimation;

@end
