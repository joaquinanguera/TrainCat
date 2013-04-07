//
//  ParticipantDetailViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "ParticipantDetailViewController.h"
#import "Participant+Extension.h"
#import "NSUserDefaults+Extensions.h"
#import "constants.h"
#import "Logger.h"
#import "ParticipantCompletionStatChartView.h"
#import "ParticipantPerformanceStatsChartView.h"
#import "SoundUtils.h"

#define kCompletionStatUninitialized -1.0f


@interface ParticipantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *statsButton;
@property (weak, nonatomic) IBOutlet ParticipantCompletionStatChartView *pieChart;
@property (weak, nonatomic) IBOutlet ParticipantPerformanceStatsChartView *lineChart;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (strong, nonatomic) NSArray *performanceStats;
@property (assign, nonatomic) double completionStat;

- (IBAction)didTapSendReport;
- (IBAction)didToggleLoginStatus:(UIButton *)sender;

@end

@implementation ParticipantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.completionStat = kCompletionStatUninitialized; // initialize completionStat to a less than 0 value so 
    
    self.view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_R/255.0 green:BACKGROUND_COLOR_G/255.0 blue:BACKGROUND_COLOR_B/255.0 alpha:255];
    self.progressLabel.text = [self.participant completionStatDescription];
    self.pieChart.backgroundColor = [UIColor clearColor];
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.pieChart chartWithCompletionStat:[self.participant completionStat]];
    
    if(self.performanceStats.count > 0) {
        // Plot both charts and keep existing positions
        [self.lineChart chartWithPoints:self.performanceStats];
    } else {
        // Hide the line chart and stat button
        self.lineChart.hidden = YES;
        self.statsButton.hidden = YES;
        
        // Move the pie chart to the center
        [self moveViewToCenter:self.pieChart];
        [self moveViewToCenter:self.loginButton];
        [self moveViewToCenter:self.logoutButton];
    }
    
    [self initControlsWithAnimation:NO];    
}

-(void)moveViewToCenter:(UIView *)view {
    CGSize winSize = self.view.frame.size;
    CGSize viewSize = view.frame.size;
    view.frame = CGRectMake((winSize.width - viewSize.width)/2 /* move to the center */,view.frame.origin.y /* same y coordinate as StoryBoard */, viewSize.width, viewSize.height);
}

-(double)completionStat {
    if(fabs(_completionStat - kCompletionStatUninitialized) < 0.001) {
        _completionStat = [self.participant completionStat];
    }
    return _completionStat;
}

-(NSArray *)performanceStats {
    if(!_performanceStats) {
        _performanceStats = [self.participant performanceStats];
    }
    return _performanceStats;
}


- (IBAction)didTapSendReport {
    [Logger printProgramForParticipant:self.participant];
    [Logger printSessionLogsForParticipant:self.participant];
    [Logger printBlocksForParticipant:self.participant];
}

-(void)initControlsWithAnimation:(BOOL)animate {
    BOOL noData = fabs(0.0 - self.completionStat) < 0.001;
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] isLoggedIn:self.participant.pid];
    self.statsButton.hidden = noData;
    
    self.navigationItem.title = [NSString stringWithFormat:(isLoggedIn ? @"Participant %04d (Playing)" : @"Participant %04d"), self.participant.pid];

    if(!animate) {
        self.loginButton.alpha = isLoggedIn ? 0.0 : 1.0;
        self.logoutButton.alpha = isLoggedIn ? 1.0 : 0.0;
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.loginButton.alpha = isLoggedIn ? 0.0 : 1.0;
            self.logoutButton.alpha = isLoggedIn ? 1.0 : 0.0;
        }];
    }    
}

- (IBAction)didToggleLoginStatus:(UIButton *)sender {
    [SoundUtils playInputClick];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger previousPid = [ud loggedIn];
    
    if(sender == self.loginButton) {
        [ud login:self.participant.pid];
    } else {
        [ud logout];
    }
    
    if(self.delegate) {
        [self.delegate didLoginNewUserWithId:[ud loggedIn] previousPid:previousPid];
    }
    
    [self initControlsWithAnimation:YES];

}


@end
