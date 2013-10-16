//
//  NRDCountingViewController.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCountingViewController.h"

#import "NRDCounter.h"

#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSUInteger const kNRDCountingStartNumber = 900;
static NSUInteger const kNRDCountingEndNumber = 1050;
static CGFloat const kNRDCountingDuration = 2.0;

@interface NRDCountingViewController ()

@property (nonatomic, strong) NSNumber *startNumber;
@property (nonatomic, strong) NSNumber *endNumber;
@property (nonatomic, strong) NSNumber *duration;

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
        NRDCounter *counter = [[NRDCounter alloc] initWithStart:self.startNumber
                                                            end:self.endNumber
                                                       duration:self.duration];
        
        return [counter count];
    }];
    
    RAC(self.countingLabel, text) = [[[self.countingButton.rac_command.executionSignals switchToLatest]
                                      map:^(NSNumber *count) {
                                          return count.stringValue;
                                      }]
                                     deliverOn:[RACScheduler mainThreadScheduler]];
}


@end
