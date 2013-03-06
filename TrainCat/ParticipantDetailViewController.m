//
//  ParticipantDetailViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "ParticipantDetailViewController.h"

@interface ParticipantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pidField;
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
    self.pidField.borderStyle = UITextBorderStyleNone;
    self.pidField.userInteractionEnabled = NO;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if(editing) {
        self.pidField.borderStyle = UITextBorderStyleRoundedRect;
        self.pidField.userInteractionEnabled = YES;
    } else {
        self.pidField.borderStyle = UITextBorderStyleNone;
        self.pidField.userInteractionEnabled = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
