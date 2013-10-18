//
//  NRDRootViewController.m
//  AnimatingChallenge
//
//  Created by Joshua Sullivan on 10/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDRootViewController.h"
#import "NRDAnimationTargetLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface NRDRootViewController () <AnimationTargetDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *startingValueField;
@property (weak, nonatomic) IBOutlet UITextField *endingValueField;
@property (weak, nonatomic) IBOutlet UISwitch *easingSwitch;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NRDAnimationTargetLayer *animationTarget;
@property (strong, nonatomic) UIView *keyboardAccessory;

@property (assign, nonatomic) NSInteger startValue;
@property (assign, nonatomic) NSInteger endValue;
@property (assign, nonatomic) CGFloat offsetValue;

- (IBAction)runTapped:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end

@implementation NRDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a number formatter to add the comma to numbers.
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    // Create the animation target object.
    self.animationTarget = [[NRDAnimationTargetLayer alloc] init];
    self.animationTarget.targetDelegate = self;
    [self.view.layer addSublayer:self.animationTarget];
    
    // Create the keyboard accessory that allows the keyboard to be dismissed.
    self.keyboardAccessory = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    self.keyboardAccessory.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDoneTapped:)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.keyboardAccessory.bounds];
    [toolbar setItems:@[spacer, doneButton]];
    [self.keyboardAccessory addSubview:toolbar];
    
    self.startingValueField.inputAccessoryView = self.keyboardAccessory;
    self.endingValueField.inputAccessoryView = self.keyboardAccessory;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

/**
 *  Create and add the CASimpleAnimation that counts from 0 to 1.
 */
- (IBAction)runTapped:(id)sender
{
    self.startValue = [self.startingValueField.text integerValue];
    self.endValue = [self.endingValueField.text integerValue];
    self.offsetValue = self.endValue - self.startValue;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.fromValue = @0.0;
    anim.toValue = @1.0;
    anim.duration = self.durationSlider.value;
    if (self.easingSwitch.on) {
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    } else {
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    anim.delegate = self;
    [self.animationTarget addAnimation:anim forKey:kAnimationProgressKey];
}

/**
 *  Update the display for the slider value.
 */
- (IBAction)sliderValueChanged:(id)sender
{
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%0.1f", self.durationSlider.value];
}

/**
 *  Dismiss the keyboard.
 */
- (IBAction)keyboardDoneTapped:(id)sender
{
    [self.startingValueField resignFirstResponder];
    [self.endingValueField resignFirstResponder];
}

#pragma mark - AnimationTargetDelegate

/**
 *  Compute the current value based on the animation progress.
 */
- (void)animationProgressDidChange:(CGFloat)animationProgress
{
    NSInteger result = roundf(animationProgress * self.offsetValue) + self.startValue;
    self.outputLabel.text = [self.numberFormatter stringFromNumber:@(result)];
}


#pragma mark - Animation delegate

/**
 *  Set the field to the target value once the animation completes.
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        self.outputLabel.text = [NSString stringWithFormat:@"%d", self.endValue];
    }
}

#pragma mark - UITextFieldDelegate

/**
 *  Restrict the input fields to integers.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *nonNumericSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    return [string rangeOfCharacterFromSet:nonNumericSet].location == NSNotFound;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
