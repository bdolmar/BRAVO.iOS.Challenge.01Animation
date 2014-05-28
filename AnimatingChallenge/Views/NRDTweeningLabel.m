//
//  NRDTweeningLabel.m
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "NRDTweeningLabel.h"

@interface NRDTweeningLabel () <NRDTweeningLayerDelegate>

@property (strong, nonatomic) NRDIntegerTweenerLayer *tweeningLayer;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation NRDTweeningLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon
{
    self.tweeningLayer = [NRDIntegerTweenerLayer new];
    self.tweeningLayer.tweeningDelegate = self;
    self.tweeningLayer.frame = CGRectMake(0., 0., 1., 1.);
    self.backgroundColor = self.backgroundColor;
    [self.layer addSublayer:self.tweeningLayer];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.locale = [NSLocale currentLocale];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.usesGroupingSeparator = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.tweeningLayer.backgroundColor = self.backgroundColor.CGColor;
}

- (void)setLabelValue:(NSInteger)labelValue
{
    [self cancelAnimation];
    
    [self setLabelValueWithoutCancellingAnimation:labelValue];
}

- (void)setLabelValue:(NSInteger)labelValue animated:(BOOL)animated duration:(CFTimeInterval)animationDuration animationStyle:(TweeningAnimationStyle)animationStyle;
{
    if (animated) {
        [self addAnimationToLabelValue:(NSInteger)labelValue duration:(CFTimeInterval)animationDuration animationStyle:animationStyle];
    } else {
        [self setLabelValue:labelValue];
    }
}

#pragma mark - NRDTweeningLayerDelegate

- (void)onValueChanged:(NSInteger)newValue
{
    [self setLabelValueWithoutCancellingAnimation:newValue];
}

#pragma mark - Private methods

- (void)setLabelValueWithoutCancellingAnimation:(NSInteger)labelValue
{
    _labelValue = labelValue;
    
    self.text = [self.numberFormatter stringFromNumber:@(labelValue)];
}

- (void)addAnimationToLabelValue:(NSInteger)labelValue duration:(CFTimeInterval)animationDuration animationStyle:(TweeningAnimationStyle)animationStyle
{
    [self cancelAnimation];
    
    [self.tweeningLayer animateFrom:self.labelValue to:labelValue duration:animationDuration style:animationStyle];
}

- (void)cancelAnimation
{
    [self.tweeningLayer cancelAnimation];
}


@end
