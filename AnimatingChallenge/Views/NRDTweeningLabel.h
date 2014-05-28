//
//  NRDTweeningLabel.h
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRDTweeningLabel : UILabel

@property (assign, nonatomic) NSInteger labelValue;

- (void)setLabelValue:(NSInteger)labelValue animated:(BOOL)animated duration:(NSTimeInterval)animationDuration;

@end
