//
//  DropboxViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "DropboxViewController.h"
#import "DSDropbox.h"
#import "Toast+UIView.h"

@interface DropboxViewController ()
- (IBAction)didClickAuthorize:(id)sender;
- (IBAction)didClickUnlink:(id)sender;
@end

@implementation DropboxViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLinkToDropbox:) name:@"DS_APPLICATION_LINKED_TO_DROPBOX" object:nil];
}

-(void)applicationDidLinkToDropbox:(NSNotification *)notification {
    NSObject *obj = [notification object];
    if([obj isKindOfClass:[NSDictionary class]]) {
        // Dictionary payload function here
    } else {
        // Dictionary payload function here
    }
   [self.view makeToast:@"Account Linked" duration:3 position:@"top"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickAuthorize:(id)sender {
    [DSDropbox linkWithDelegate:self];
}

- (IBAction)didClickUnlink:(id)sender {
    [DSDropbox unlinkWithDelegate:self];
}
@end
