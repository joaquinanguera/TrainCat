//
//  ParticipantDetailViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "ParticipantDetailViewController.h"
#import "SessionManager.h"
#import "constants.h"
#import "Logger.h"

@interface ParticipantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pidField;
@property (weak, nonatomic) IBOutlet UISwitch *loggedInField;
- (IBAction)didTapSendReport;

@end

@implementation ParticipantDetailViewController

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.pidField.text = [NSString stringWithFormat:@"%04d", self.participant.pid];
    self.loggedInField.on = [SessionManager isLoggedIn:self.participant.pid];
    [self disableControls];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if(editing) {
        self.pidField.borderStyle = UITextBorderStyleRoundedRect;
        self.pidField.userInteractionEnabled = YES;
        self.loggedInField.userInteractionEnabled = YES;
    } else {
        self.participant.pid = [self.pidField.text integerValue];
        [self.delegate participantDetailViewControllerDidSave:self.participant withAutoLogin:self.loggedInField.on];
        [self disableControls];
    }
}

-(void)disableControls {
    self.pidField.borderStyle = UITextBorderStyleNone;
    self.pidField.userInteractionEnabled = NO;
    self.loggedInField.userInteractionEnabled = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSendReport {
    [Logger printProgramForParticipant:self.participant];
    [Logger printSessionLogsForParticipant:self.participant];
    [Logger printBlocksForParticipant:self.participant];
}
@end
