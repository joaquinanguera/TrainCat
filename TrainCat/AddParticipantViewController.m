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
    
	self.autoLoginField.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLoginFieldDefault"];
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
    self.participant.pid = [self.pidField.text integerValue];
    [self.delegate addParticipantViewControllerDidSave];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(self.autoLoginField.on) {
        [ud setInteger:self.participant.pid forKey:@"loggedInPid"];
    }
    [ud setBool:self.autoLoginField.on forKey:@"autoLoginFieldDefault"];
    [ud synchronize];
}
@end

