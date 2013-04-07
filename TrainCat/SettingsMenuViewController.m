//
//  SettingsMenuViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 06/04/13.
//
//

#import "SettingsMenuViewController.h"

@interface SettingsMenuViewController ()

@end

@implementation SettingsMenuViewController

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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSArray *vcs = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcs[vcs.count-2] animated:NO];
    }
    [super viewWillDisappear:animated];
}
@end
