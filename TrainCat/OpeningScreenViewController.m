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
    self.view.backgroundColor = getBackgroundColor();
}

-(void)viewDidAppear:(BOOL)animated {    
    [self performSegueWithIdentifier:@"beginGame" sender:self];
}

@end
