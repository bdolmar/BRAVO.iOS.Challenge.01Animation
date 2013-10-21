//
//  NRDCountingViewController.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCountingViewController.h"

#import "NRDCounter.h"
#import "NRDProgressSignaler.h"
#import "NRDRepeatingSignaler.h"

#import <easing.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

static NSUInteger const kNRDCountingStartNumber = 900;
static NSUInteger const kNRDCountingEndNumber = 1050;
static CGFloat const kNRDCountingDuration = 2.0;

@interface NRDCountingViewController ()

@property (nonatomic, strong) NSNumber *startNumber;
@property (nonatomic, strong) NSNumber *endNumber;
@property (nonatomic, strong) NSNumber *duration;

- (CGFloat)timeIntervalPerTickForStart:(NSNumber *)start end:(NSNumber *)end duration:(NSNumber *)duration;

@end

@implementation NRDCountingViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.startNumber = @(kNRDCountingStartNumber);
        self.endNumber = @(kNRDCountingEndNumber);
        self.duration = @(kNRDCountingDuration);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    @weakify(self);
    self.countingButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        @strongify(self);

        CGFloat timeInterval = [self timeIntervalPerTickForStart:self.startNumber end:self.endNumber duration:self.duration];

        NRDCounter *counter = [NRDCounter counterWithStart:self.startNumber end:self.endNumber];
        NRDRepeatingSignaler *timingSignaler = [NRDRepeatingSignaler repeatingSignalerWithWithInitialFrequency:@((1 / timeInterval))];
        NRDProgressSignaler *progressSignaler = [NRDProgressSignaler progressSignalerWithDuration:self.duration.doubleValue easingFunction:LinearInterpolation];
        
        return [counter countingSignalWithProgressSignal:[progressSignaler progressSignalWithTimingSignal:[timingSignaler timingSignal]]];
    }];
    
    RAC(self.countingLabel, text) = [[[self.countingButton.rac_command.executionSignals switchToLatest]
                                       map:^(NSNumber *count) {
                                           return count.stringValue;
                                       }]
                                     deliverOn:[RACScheduler mainThreadScheduler]];
}

- (CGFloat)timeIntervalPerTickForStart:(NSNumber *)start end:(NSNumber *)end duration:(NSNumber *)duration
{
    return duration.doubleValue / abs(start.doubleValue - end.doubleValue);
}

@end
