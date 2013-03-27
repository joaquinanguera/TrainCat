//
//  OpeningScreenViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//
//

#import "OpeningScreenViewController.h"

@interface OpeningScreenViewController ()

@end

@implementation OpeningScreenViewController

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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self performSegueWithIdentifier:@"beginGame" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
