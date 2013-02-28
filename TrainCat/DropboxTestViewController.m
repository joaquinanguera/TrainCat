//
//  DropboxTestViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 14/02/13.
//
//

#import "DropboxTestViewController.h"
#import "DSDropbox.h"
#import <Dropbox/Dropbox.h>

@interface DropboxTestViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@end

@implementation DropboxTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // initialization code
    }
    return self;
}
- (IBAction)didClickActivateButton {
    [[DBAccountManager sharedManager] linkFromController:self];
}
- (IBAction)didClickGenerateRandomFileButton {
    NSString *randomPath = [[NSString alloc] initWithFormat:@"r%d.txt", arc4random()];
    [DSDropbox writeToFile:randomPath theString:@"Hallelujah! Our DropBox code works. But before we celebrate, we have much to do, such as running this task on a separate background thread so it doesn't lock up the application during network activity, check for success or failure of the synch and displaying activity status gear icons to show the user that network activity is in progress.\n\nNetwork activity is an unkind beast."];
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
