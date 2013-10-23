//
//  NRDMainAnimateViewController.m
//  AnimatingChallenge
//
//  Created by Mike Dockerty on 10/15/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDMainAnimateViewController.h"
#import "CPAccelerationTimer.h"

// Assumption: the finish value will be larger than the start value
NSInteger const counterStart = 900;
NSInteger const counterFinish = 1050;

CGFloat const animationDuration = 2.0f;

@interface NRDMainAnimateViewController ()

- (IBAction)runButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property NSInteger counter;

@end

@implementation NRDMainAnimateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.counter = counterStart;
}

- (void)updateCounterLabel
{
    self.counterLabel.text = [NSString stringWithFormat:@"%i", self.counter];
}

- (IBAction)runButtonTapped:(id)sender {
    CPAccelerationTimerTick update = ^(NSUInteger tickIndex) {
        self.counter += 1;
        [self updateCounterLabel];
	};
    
	CPAccelerationTimerCompletion reset = ^{
        // empty for now
	};
    
	[[CPAccelerationTimer accelerationTimerWithTicks:counterFinish - counterStart
									   totalDuration:animationDuration
									   controlPoint1:CGPointMake(0.0, 0.0) // ease in
									   controlPoint2:CGPointMake(0.58, 1.0) // ease out
										atEachTickDo:update
										  completion:reset]
	 run];
}

@end
