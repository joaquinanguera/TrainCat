//
//  ParticipantDetailViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "ParticipantDetailViewController.h"

@interface ParticipantDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (retain, nonatomic) IBOutlet UITextField *txtParticipant;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UISwitch *boolShowPassword;
- (void)configureView;
@end

@implementation ParticipantDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.txtParticipant.text = [[self.detailItem valueForKey:@"pid"] description];
        NSString *txtPassword = [[self.detailItem valueForKey:@"password"] description];
        self.txtPassword.text =
            [[NSUserDefaults standardUserDefaults] boolForKey:@"showPassword"] ?
            txtPassword
        :   [@"" stringByPaddingToLength:txtPassword.length withString:@"*" startingAtIndex:0];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.boolShowPassword setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"showPassword"] animated:YES];
    [self.boolShowPassword addTarget:self action:@selector(handleBoolShowPasswordChange:) forControlEvents:UIControlEventValueChanged];
    [self configureView];
}

-(void)handleBoolShowPasswordChange:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:self.boolShowPassword.on forKey:@"showPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Participant", @"Participant");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)dealloc {
    [_txtParticipant release];
    [_txtPassword release];
    [_boolShowPassword release];
    [super dealloc];
}
@end