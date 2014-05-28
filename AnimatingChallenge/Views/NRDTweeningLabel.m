//
//  NRDTweeningLabel.m
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDTweeningLabel.h"

@implementation NRDTweeningLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setLabelValue:(NSInteger)labelValue
{
    [self cancelAnimation];
    
    [self setLabelValueWithoutCancellingAnimation:labelValue];
}

- (void)setLabelValue:(NSInteger)labelValue animated:(BOOL)animated duration:(NSTimeInterval)animationDuration
{
    if (animated) {
        [self addAnimationToLabelValue:(NSInteger)labelValue duration:(NSTimeInterval)animationDuration];
    } else {
        [self setLabelValue:labelValue];
    }
}

#pragma mark - Private methods

- (void)setLabelValueWithoutCancellingAnimation:(NSInteger)labelValue
{
    _labelValue = labelValue;
    
    self.text = [NSString stringWithFormat:@"%d", labelValue];
}

- (void)addAnimationToLabelValue:(NSInteger)labelValue duration:(NSTimeInterval)animationDuration
{
    [self cancelAnimation];
    
}

- (void)cancelAnimation
{
    // TODO
}


@end
