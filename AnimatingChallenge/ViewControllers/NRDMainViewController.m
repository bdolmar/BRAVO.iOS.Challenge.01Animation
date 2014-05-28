//
//  NRDMainViewController.m
//  AnimatingChallenge
//
//  Created by Russ Shanahan on 5/28/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDMainViewController.h"
#import "NRDTweeningLabel.h"

@interface NRDMainViewController ()

@property (weak, nonatomic) IBOutlet NRDTweeningLabel *numberLabel;

- (IBAction)onRunTapped:(id)sender;

@end

@implementation NRDMainViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRunTapped:(id)sender
{
    self.numberLabel.text = @"Hello";
}

@end
