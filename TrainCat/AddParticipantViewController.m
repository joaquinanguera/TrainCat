//
//  AddParticipantViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "AddParticipantViewController.h"
#import "Participant+Extension.h"
#import "ViewWithToast.h"
#import "Toast+UIView.h"

@interface AddParticipantViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pidField;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginField;
- (IBAction)didCancel:(UIBarButtonItem *)sender;
- (IBAction)didSave:(UIBarButtonItem *)sender;

@end

@implementation AddParticipantViewController

#define AUTOLOGIN_FIELD_KEY @"autoLoginFieldDefault"

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
    
    UIImageView * invalidField = [[UIImageView  alloc] initWithImage:[UIImage  imageNamed:@"iconInvalidField.png"]];
    self.pidField.delegate = self;
    self.pidField.rightView = invalidField;
    ((ViewWithToast *)self.view).toastBackgroundColor = [UIColor redColor];
}

-(void)viewDidAppear:(BOOL)animated {
    self.pidField.rightViewMode = UITextFieldViewModeNever;
    self.pidField.text = @"";
    self.autoLoginField.on = [[NSUserDefaults standardUserDefaults] boolForKey:AUTOLOGIN_FIELD_KEY];
    [self.pidField becomeFirstResponder];    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.pidField setRightViewMode:UITextFieldViewModeNever];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didSave:nil];
    return YES;
}

-(void)showErrorWithMessage:(NSString *)message title:(NSString *)title {
    [self.view makeToast:message duration:3.0 position:@"top" title:title];
    self.pidField.rightViewMode = UITextFieldViewModeUnlessEditing;
}

- (IBAction)didCancel:(UIBarButtonItem *)sender {
    [self.delegate addParticipantViewControllerDidCancel:self participant:self.participant];
}

- (IBAction)didSave:(UIBarButtonItem *)sender {
    if([[self.pidField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self showErrorWithMessage:@"A Participant's identity may not be a blank slate. Try again might you?" title:@"Blank Participant Id"];
    } else {
        self.participant.pid = [self.pidField.text integerValue];
        [self.delegate addParticipantViewControllerDidSave:self participant:self.participant autoLogin:self.autoLoginField.on];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:self.autoLoginField.on forKey:AUTOLOGIN_FIELD_KEY];
        [ud synchronize];
    }
}
@end

