//
//  NRDCountingViewController.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCountingViewController.h"

#import "NRDCounter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static NSUInteger const kNRDCountingStartNumber = 900;
static NSUInteger const kNRDCountingEndNumber = 1050;
static CGFloat const kNRDCountingDuration = 2.0;

@interface NRDCountingViewController ()

@end

@implementation NRDCountingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.countingButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        NRDCounter *counter = [[NRDCounter alloc] initWithStart:@(kNRDCountingStartNumber)
                                                            end:@(kNRDCountingEndNumber)
                                                       duration:@(kNRDCountingDuration)];
        
        return [counter count];
    }];
    
    RAC(self.countingLabel, text) = [[[self.countingButton.rac_command.executionSignals switchToLatest] map:^(NSNumber *count) {
        return count.stringValue;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}


@end
