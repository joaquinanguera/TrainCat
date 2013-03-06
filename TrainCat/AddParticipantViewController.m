//
//  AddParticipantViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "AddParticipantViewController.h"

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
    
	self.autoLoginField.on = [[NSUserDefaults standardUserDefaults] boolForKey:AUTOLOGIN_FIELD_KEY];
    [self.pidField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didCancel:(UIBarButtonItem *)sender {
    [self.delegate addParticipantViewControllerDidCancel:self.participant];
}

- (IBAction)didSave:(UIBarButtonItem *)sender {
    if([[self.pidField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed to create new participant"
                                                          message:@"Participant ID cannot be blank"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        self.participant.pid = [self.pidField.text integerValue];
        [self.delegate addParticipantViewControllerDidSave:self.participant withAutoLogin:self.autoLoginField.on];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:self.autoLoginField.on forKey:AUTOLOGIN_FIELD_KEY];
        [ud synchronize];
    }
}
@end

