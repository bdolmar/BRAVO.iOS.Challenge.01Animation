//
//  NRDCountingViewController.m
//  AnimatingChallenge
//
//  Created by Dan Kane on 10/17/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NRDCountingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NRDStepper.h"

static const NSUInteger kDefaultStart = 900;
static const NSUInteger kDefaultFinish = 1050;
static const NSTimeInterval kDefaultTimeInterval = 2.0f;

@interface NRDCountingViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UITextField *beginTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UITextField *curveTypeTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *counterProgress;

// UI Management
@property (weak, nonatomic) UIControl *activeControl;
@property (assign, nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (assign, nonatomic) UIViewAnimationCurve keyboardAnimationCurve;
@property (assign, nonatomic) CGRect keyboardEndFrame;

// Functionality
@property (assign, nonatomic) NSRange countRange;
@property (assign, nonatomic) NSInteger countDirection;
@property (strong, nonatomic) NRDStepper *stepper;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) NSTimeInterval elapsedTime;

@end

@implementation NRDCountingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.stepper = [NRDStepper new];
        
        // Set defaults
        [self setCountRangeForBegin:kDefaultStart end:kDefaultFinish];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stepper.totalDuration = kDefaultTimeInterval;
    
    // Specify a built-in curve type
    self.stepper.timerCurveType = TimerCurveTypeLinear;
    
    // Or manually specify a timing function
    //self.stepper.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.075 :0.82 :0.165 :1.0];
    
    
    // Configure the UI
    self.counterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)kDefaultStart];
    self.beginTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)kDefaultStart];
    self.endTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)kDefaultFinish];
    self.durationTextField.text = [NSString stringWithFormat:@"%.2f", kDefaultTimeInterval];
    self.durationSlider.value = kDefaultTimeInterval;
    self.curveTypeTextField.text = [NRDStepper nameForCurve:self.stepper.timerCurveType];
    
    UIPickerView *curveTypePickerView = [UIPickerView new];
    curveTypePickerView.delegate = self;
    curveTypePickerView.dataSource = self;
    self.curveTypeTextField.inputView = curveTypePickerView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)runTapped:(id)sender
{
    // Reset
    [self endEditing:nil];
    [self.displayLink invalidate];
    self.elapsedTime = 0;
    
    self.counterLabel.text = [NSString stringWithFormat:@"%d", self.countRange.location];
    
    if (self.countRange.length > 0) {
        // Start updating
        self.counterProgress.progress = 0;
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    else {
        self.counterProgress.progress = 1;
    }
}

- (IBAction)endEditing:(id)sender
{
    [self.durationTextField resignFirstResponder];
    [self.activeControl resignFirstResponder];
}

- (IBAction)durationSliderChanged:(id)sender {
    // Set the text field
    self.durationTextField.text = [NSString stringWithFormat:@"%.2f", self.durationSlider.value];
    
    // Update the stepper
    self.stepper.totalDuration = self.durationSlider.value;
}

#pragma mark - UI Methods

- (void)updateDisplay:(CADisplayLink *)displayLink
{
    // Determine current progress
    self.elapsedTime += displayLink.duration * displayLink.frameInterval;
    NSUInteger steps;
    if (self.elapsedTime >= self.stepper.totalDuration) {
        steps = self.countRange.length;
        self.counterProgress.progress = 1;
        
        // Stop updating
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    else {
        steps = [self.stepper stepAtTime:self.elapsedTime];
        self.counterProgress.progress = self.stepper.progress;
    }
    
    self.counterLabel.text = [NSString stringWithFormat:@"%d", self.countRange.location + steps * self.countDirection];
}

- (void)moveView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.keyboardAnimationDuration];
    [UIView setAnimationCurve:self.keyboardAnimationCurve];
    
    if (self.activeControl && !CGRectIsEmpty(self.keyboardEndFrame)) {
        // Move the view to the recorded keyboard position
        CGFloat keyboardTop = CGRectGetMinY(self.keyboardEndFrame);
        CGFloat controlBottom = CGRectGetMaxY(self.activeControl.frame);
        CGFloat boundsTopAdjustment = controlBottom - keyboardTop + 10;
        CGRect bounds = self.view.frame;
        if (bounds.origin.y + boundsTopAdjustment > 0) {
            bounds.origin.y += boundsTopAdjustment;
        }
        self.view.bounds = bounds;
    }
    else {
        // Reset the view
        self.view.bounds = self.view.frame;
    }
    
    [UIView commitAnimations];
}

#pragma mark - Setters

- (void)setCountRangeForBegin:(NSUInteger)begin end:(NSUInteger)end
{
    self.countRange = NSMakeRange(begin, abs(end - begin));
    self.countDirection = end < begin ? -1 : 1;
}

- (void)setCountRange:(NSRange)countRange
{
    _countRange = countRange;
    self.stepper.totalSteps = self.countRange.length;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeControl = textField;
    [self moveView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.beginTextField || textField == self.endTextField) {
        // Get and store the new value
        NSInteger begin = [self.beginTextField.text integerValue];
        NSInteger end = [self.endTextField.text integerValue];
        [self setCountRangeForBegin:begin end:end];
        
        // Update the stepper and UI
        self.stepper.totalSteps = self.countRange.length;
        self.counterLabel.text = [NSString stringWithFormat:@"%d", begin];
        self.counterProgress.progress = 0;
    }
    else if (textField == self.durationTextField) {
        // Get the new value and clamp to range
        CGFloat newDuration = [textField.text floatValue];
        newDuration = MAX(MIN(3.0, newDuration), 0.5);
        
        // Update the UI
        self.durationSlider.value = newDuration;
        self.durationTextField.text = [NSString stringWithFormat:@"%.2f", newDuration];
        
        // Update the stepper
        self.stepper.totalDuration = newDuration;
    }
    self.activeControl = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.curveTypeTextField) {
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return TimerCurveTypeCount;
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TimerCurveType curveType = (TimerCurveType)row;
    return [NRDStepper nameForCurve:curveType];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TimerCurveType curveType = (TimerCurveType)row;
    self.curveTypeTextField.text = [NRDStepper nameForCurve:curveType];
    self.stepper.timerCurveType = curveType;
}

#pragma mark - NSNotificationCenter observers

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Record animation info
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    self.keyboardAnimationDuration = animationDuration;
    self.keyboardAnimationCurve = animationCurve;
    self.keyboardEndFrame = keyboardEndFrame;
    
    // Move view to compensate for keyboard
    [self moveView];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // Reset view
    self.keyboardEndFrame = CGRectNull;
    [self moveView];
}

@end
