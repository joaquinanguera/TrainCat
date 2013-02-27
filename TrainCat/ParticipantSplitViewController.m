//
//  ParticipantSplitViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "ParticipantSplitViewController.h"
#import "ParticipantMasterViewController.h"

@interface ParticipantSplitViewController ()

@end

@implementation ParticipantSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationController *navigationController = [self.viewControllers lastObject];
        self.delegate = (id)navigationController.topViewController;
        
        // We don't set managed through the split view controller. Instead we take it from the app itself. Maybe we could try it this way too.
        //UINavigationController *masterNavigationController = self.viewControllers[0];
        //ParticipantMasterViewController *controller = (CoreDataTemplateMasterViewController *)masterNavigationController.topViewController;
        //controller.managedObjectContext = self.managedObjectContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
