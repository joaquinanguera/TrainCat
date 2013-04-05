//
//  OpeningScreenViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//
//

#import "OpeningScreenViewController.h"
#import "constants.h"
#import "PCPieChart.h"

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
    self.view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_R/255.0 green:BACKGROUND_COLOR_G/255.0 blue:BACKGROUND_COLOR_B/255.0 alpha:255];
    //[self makePieChart];
}

-(void)viewDidAppear:(BOOL)animated {    
    [self performSegueWithIdentifier:@"beginGame" sender:self];
}

-(void)makePieChart {
    CGSize winSize = self.view.frame.size;
    int size = floor(MIN(winSize.width, winSize.height));
    size = 600;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    //[pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:size/2];
    //[pieChart setSameColorLabel:YES];

    [self.view addSubview:pieChart];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];

    
    NSMutableArray *components = [NSMutableArray array];
    // Complete
    PCPieComponent *completedComponent = [PCPieComponent pieComponentWithTitle:@"Completed" value:0.8];
    //[completedComponent setColour:PCColorYellow];
    [completedComponent setColour:PCColorOrange];
    [components addObject:completedComponent];
    
    // Pending
    PCPieComponent *pendingComponent = [PCPieComponent pieComponentWithTitle:@"Pending" value:0.2];
    [pendingComponent setColour:PCColorRed];
    //[pendingComponent setColour:PCColorGreen];
    [components addObject:pendingComponent];
    //[pendingComponent setColour:PCColorOrange];
    //[pendingComponent setColour:PCColorRed];
    //[pendingComponent setColour:PCColorBlue];
    
    
    [pieChart setComponents:components];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
