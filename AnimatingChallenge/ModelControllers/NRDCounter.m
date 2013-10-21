//
//  NRDCounter.m
//  AnimatingChallenge
//
//  Created by Brendon Justin on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCounter.h"

#import <easing.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRDCounter ()

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;
@property (nonatomic, strong) NSNumber *progress;

/**
 Dispose to stop counting, if counting.
 */
@property (nonatomic, strong) RACDisposable *countingDisposable;

@end

@implementation NRDCounter

+ (instancetype)counterWithStart:(NSNumber *)start end:(NSNumber *)end
{
    NRDCounter *counter = [[NRDCounter alloc] initWithStart:start end:end];
    return counter;
}

- (instancetype)initWithStart:(NSNumber *)start end:(NSNumber *)end
{
    if ((self = [super init])) {
        self.start = start;
        self.end = end;
        self.progress = @0;
    }
    
    return self;
}

- (RACSignal *)countingSignalWithProgressSignal:(RACSignal *)progressSignal
{
    CGFloat startValue = self.start.doubleValue;
    CGFloat endValue = self.end.doubleValue;
    
    NSInteger sign = (startValue < endValue) ? 1 : -1;
    
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        self.countingDisposable = [[[progressSignal map:^(NSNumber *progress) {
            NSUInteger count = progress.doubleValue * (endValue - startValue) + startValue;
            
            return @(count);
        }] doNext:^(NSNumber *count) {
            if ((sign == 1) ? (count.doubleValue > endValue) : (count.doubleValue < endValue)) {
                [subscriber sendCompleted];
                
                [self.countingDisposable dispose];
                self.countingDisposable = nil;
            }
        }] subscribe:subscriber];
        
        return self.countingDisposable;
    }];
}

@end
