//
//  OpeningScreenViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//
//

#import "OpeningScreenViewController.h"
#import "Constants.h"
#import "PCPieChart.h"

@implementation OpeningScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_R/255.0 green:BACKGROUND_COLOR_G/255.0 blue:BACKGROUND_COLOR_B/255.0 alpha:255];
}

-(void)viewDidAppear:(BOOL)animated {    
    [self performSegueWithIdentifier:@"beginGame" sender:self];
}

@end
