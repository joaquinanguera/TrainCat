//
//  SettingsViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import "SettingsAuthViewController.h"
#import "NSUserDefaults+Extensions.h"
#import "Toast+UIView.h"
#import "ViewWithToast.h"
#import "constants.h"

@interface SettingsAuthViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)didTapLogin;

@end

@implementation SettingsAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_R/255.0 green:BACKGROUND_COLOR_G/255.0 blue:BACKGROUND_COLOR_B/255.0 alpha:255];
    self.passwordField.delegate = self;
    UIImageView * invalidField = [[UIImageView  alloc] initWithImage:[UIImage  imageNamed:@"iconInvalidField.png"]];
    [self.passwordField setRightView:invalidField];
    ((ViewWithToast *)self.view).toastBackgroundColor = [UIColor redColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.passwordField setRightViewMode:UITextFieldViewModeNever];
    self.passwordField.text = @"";
    [self.passwordField becomeFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.passwordField setRightViewMode:UITextFieldViewModeNever];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didTapLogin];
    return YES;
}


- (IBAction)didTapLogin {
    [self.passwordField resignFirstResponder];
    if([[self.passwordField text] isEqualToString:[[NSUserDefaults standardUserDefaults] settingsPassword]]) {
        [self performSegueWithIdentifier:@"segueToSettings" sender:self];
    } else {
        [self.view makeToast:@"Thy secret word is sullied. Imposter might you be. Try again might you?" duration:3.0 position:@"top"];
        [self.passwordField setRightViewMode:UITextFieldViewModeUnlessEditing];
    }
}

@end
