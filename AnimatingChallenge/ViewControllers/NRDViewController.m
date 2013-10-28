//
//  NRDViewController.m
//  ArbitraryAnimation
//
//  Created by Ben Dolmar on 8/30/13.
//  Copyright (c) 2013 Ben Dolmar. All rights reserved.
//

#import "NRDViewController.h"
#import "NRDValueAnimator.h"
#import "UIFont+Nerdery.h"

@interface NRDViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UITextField *startTextField;
@property (strong, nonatomic) IBOutlet UITextField *endTextField;
@property (strong, nonatomic) IBOutlet UITextField *durationTextField;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) NSArray *formFields;
@property (strong, nonatomic) IBOutlet UIButton *runButton;
@property (strong, nonatomic) NRDValueAnimator *animator;

@property (strong, nonatomic) NSNumberFormatter *valueNumberFormatter;
@property (strong, nonatomic) NSNumberFormatter *durationNumberFormatter;

@end

@implementation NRDViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (void)commonInitializer
{
    self.valueNumberFormatter = [[NSNumberFormatter alloc] init];
    self.valueNumberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    self.valueNumberFormatter.groupingSize = 3;
    self.valueNumberFormatter.usesGroupingSeparator = YES;
    
    self.durationNumberFormatter = [[NSNumberFormatter alloc] init];
    self.durationNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.animator = [[NRDValueAnimator alloc] initWithStartValue:@900
                                                        endValue:@1050
                                                        duration:2.0];
    self.animator.easingEquation = NRDEaseQuarticOut;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.countdownLabel.font = [self.countdownLabel.font fontWithProportionalNumberSpacing];
    
    self.countdownLabel.text = [self.valueNumberFormatter stringFromNumber:self.animator.startValue];
    self.startTextField.text = [self.valueNumberFormatter stringFromNumber:self.animator.startValue];
    self.endTextField.text = [self.valueNumberFormatter stringFromNumber:self.animator.endValue];
    self.durationTextField.text = [self.durationNumberFormatter stringFromNumber:@(self.animator.duration)];
    
    self.formFields = @[self.startTextField, self.endTextField, self.durationTextField];
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = self.contentView.frame.size;
    
    [self registerForKeyboardNotifications];
}

#pragma mark - Keyboard Notification Handlers

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    scrollView.scrollEnabled = YES;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    CGPoint fieldOrigin = [self.activeField.superview convertPoint:self.activeField.frame.origin toView:self.view];
    if (!CGRectContainsPoint(aRect, fieldOrigin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldOrigin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIScrollView *scrollView = (UIScrollView *)self.view;

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger textFieldIndex = [self.formFields indexOfObject:textField];
    NSAssert(textFieldIndex != NSNotFound, @"All text fields managed by this form should be included in the self.formFields.");
    
    NSUInteger textFieldActiveIndex = textFieldIndex + 1;
    if (textFieldActiveIndex >= [self.formFields count]) {
        [self.view endEditing:YES];
    }else{
        [self.formFields[textFieldActiveIndex] becomeFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    UIScrollView *scrollView = (UIScrollView *)self.view;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= scrollView.contentInset.bottom;
    
    CGPoint fieldOrigin = [self.activeField.superview convertPoint:self.activeField.frame.origin toView:self.view];
    if (!CGRectContainsPoint(aRect, fieldOrigin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, scrollView.contentInset.bottom);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}


#pragma mark - IBActions

- (IBAction)runButtonTapped:(id)sender
{
    self.runButton.enabled = NO;
    self.animator.startValue = [self.valueNumberFormatter numberFromString:self.startTextField.text];
    self.animator.endValue = [self.valueNumberFormatter numberFromString:self.endTextField.text];
    self.animator.duration = [[self.durationNumberFormatter numberFromString:self.durationTextField.text] doubleValue];
    
    __weak __typeof(&*self)weakSelf = self;
   [self.animator startAnimationUpdate:^(NSNumber *currentValue, NRDValueAnimatorState state) {
       weakSelf.countdownLabel.text = [weakSelf.valueNumberFormatter stringFromNumber:currentValue];
   }
                            completion:^(BOOL finished) {
                                weakSelf.runButton.enabled = YES;
                            }];
}

@end
