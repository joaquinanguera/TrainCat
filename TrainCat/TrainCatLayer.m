//
//  HelloWorldLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
#import "constants.h"
#import "TrainCatLayer.h"
#import "AppDelegate.h"
#import "Participant+Extension.h"
#import "AppDelegate.h"
#import "StimulusPack.h"
#import "StimulusCategory.h"
#import "StimulusBlock.h"
#import "StimulusList.h"
#import "RangeArray.h"
#import "NSMutableArray+Shuffling.h"
#import "StimulusSession.h"
#import "StimulusLayer.h"
#import "GameState.h"
#import "ResponseLayer.h"
#import "FeedbackLayer.h"

#pragma mark - HelloWorldLayer
@interface TrainCatLayer()
@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) Participant *participant;
@property (nonatomic, strong) NSArray *program;
@property (nonatomic, strong) StimulusLayer *stim;
@property (nonatomic, strong) GameState *gs;
@property (nonatomic, strong) ResponseLayer *response;
@property (nonatomic, strong) FeedbackLayer *feedback;
@property (nonatomic, assign) int correctResponse; // RESPONSE_LEFT, RESPONSE_RIGHT


@property (nonatomic, strong) NSArray *stimuli;
@property (nonatomic, strong) NSString *exemplarLeft;
@property (nonatomic, strong) NSString *exemplarRight;
@end

// HelloWorldLayer implementation
@implementation TrainCatLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TrainCatLayer *gameLayer = [TrainCatLayer node];
	
	// add layer as a child to scene
	[scene addChild: gameLayer];
    //[scene addChild:self.stim];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) { // ccc4(220, 220, 220, 255)
        self.gs = self.participant.gameState;
        self.program = [NSKeyedUnarchiver unarchiveObjectWithData:self.participant.program];
        
        self.stim = [[StimulusLayer alloc] init];
        self.stim.delegate = self;
        
        self.response = [[ResponseLayer alloc] init];
        self.response.delegate = self;
        self.response.visible = NO;
        
        self.feedback = [[FeedbackLayer alloc] init];
        self.feedback.delegate = self;
        self.feedback.visible = NO;
        
        [self addChild:self.stim];
        [self addChild:self.response];
        [self addChild:self.feedback];
        
        [self scheduleOnce:@selector(beginGame) delay:500.0/1000.0];
	}
	return self;
}

-(void)onExit {
    [self saveState];
}

-(void)beginGame {
    [self clearState];
    [self updateStimulus];
}

-(void)clearState {
    self.gs.sessionID = 0;
    self.gs.blockID = 0;
    self.gs.listID = 0;
    self.gs.trialCount = 0;
    [self saveState];
}

-(void)updateStimulus { 
    BOOL willShowStimlus = YES;
    NSArray *sessions = [StimulusPack sessions];
    StimulusSession *session = self.program[self.gs.sessionID];
    StimulusCategory *category = sessions[session.categoryID];
    
    if(self.gs.trialCount >= MAX_TRIALS_PER_STIMULUS_BLOCK) {
        self.gs.trialCount = 0;
        self.gs.listID = 0;
        self.gs.blockID++;
        if(self.gs.blockID >= (category.blocks.count-1)) { // Blocks exhausted. We need a new session. You might want to call some other screen here. Remember to save state first
            NSLog(@"Session Complete!");
            //willShowStimlus = NO;
            self.gs.blockID = 0;
            self.gs.sessionID++;
            if(self.gs.sessionID >= sessions.count) { // Sessions/Categories exhausted. Show Game Over! screen. Remember to save state first
                willShowStimlus = NO;
                NSLog(@"Game Over!");
            } else {
                session = self.program[self.gs.sessionID];
                category = sessions[session.categoryID];
            }
        }
    }
        
    [self saveState];
    [self printGameState];
    
    if(willShowStimlus) {
        self.exemplarLeft = category.exemplarLeft;
        self.exemplarRight = category.exemplarRight;
        StimulusBlock *block = category.blocks[self.gs.blockID];
        StimulusList *list = block.lists[self.gs.listID];
        self.stimuli = list.stimuli;
        [self showStimulus];
    }
}

-(void)showStimulus {
    NSString *morph = self.stimuli[arc4random() % self.stimuli.count];
    [self setCorrectResponseFromMorphName:morph];
    [self.stim showStimulusWithExemplarLeftPath:self.exemplarLeft exemplarRightPath:self.exemplarRight morphPath:morph];
}

-(void)setCorrectResponseFromMorphName:(NSString *)morph {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:nil error:nil];
    NSArray *matches = [regex matchesInString:morph options:0 range:NSMakeRange(0, [morph length])];
    if(matches.count) {
        NSTextCheckingResult *match = [matches lastObject];
        NSRange matchRange = [match range];
        NSString *stimTag = [morph substringWithRange:matchRange];
        self.correctResponse = ([stimTag integerValue] <= 50) ? RESPONSE_LEFT :RESPONSE_RIGHT;
        NSLog(@"%@ - %d", stimTag, self.correctResponse);
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Fatal error"
                                                          message:@"Stimulus label is invalid. Contact the developer."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];        
    }
}

-(void)stimulusDidFinish {
    //self.response.visible = YES;
    //[self.response getResponse];
    // Debug
    [self feedbackDidFinish];
}


-(void)didRespond:(NSInteger)responseTag {
    self.response.visible = NO;
    [self grade:responseTag];
}

-(void)grade:(NSInteger)responseTag {
    int gradeCode;
    
    switch(responseTag) {
        case RESPONSE_LEFT:
            gradeCode = self.correctResponse == RESPONSE_LEFT ? GRADE_CORRECT : GRADE_INCORRECT;
            break;
        case RESPONSE_RIGHT:
            gradeCode = self.correctResponse == RESPONSE_RIGHT ? GRADE_CORRECT : GRADE_INCORRECT;
            break;
        default:
            gradeCode = GRADE_RESPONSE_SKIPPED;
            break;
            
    }
    [self.feedback clear];
    self.feedback.visible = YES;
    [self.feedback showFeedback:gradeCode];
}

-(void)feedbackDidFinish {
    self.feedback.visible = NO;
    self.gs.trialCount++;
    [self updateStimulus];
}

-(void)saveState {
    NSError *error = nil;
    if (![self.moc save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed to save the game progress! Contact the developer."
                                                          message:[error domain] /* , [error userInfo] */
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    NSLog(@"Saved state.");
}

-(Participant *)participant {
    if(!_participant) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:self.moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSNumber *pid = [NSNumber numberWithInt:0];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid=%@", pid];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *array = [self.moc executeFetchRequest:request error:&error];
        if(array == nil) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"There was an error reading the Participant database. Contact the developer."
                                                              message:[error domain] /* , [error userInfo] */
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else if(!array.count) {
            _participant = [NSEntityDescription
             insertNewObjectForEntityForName:@"Participant"
             inManagedObjectContext:self.moc];
            _participant.pid = 0;
            [self saveState];
            
        } else {
            _participant = array[0];
        }
        
    }
    return _participant;
}

#pragma mark Debug functions

-(void)printGameState {
    GameState *gs = self.participant.gameState;
    NSLog(@"GameState = [CategoryID:%d, BlockID:%d, ListID:%d, TrialCount:%d]", gs.sessionID, gs.blockID, gs.listID, gs.trialCount);
}


-(void)printStimulusPack {
    NSArray *stim = [StimulusPack sessions];
    for(StimulusCategory *cat in stim) {
        NSLog(@"%@", cat);
    }
}

-(NSManagedObjectContext *) moc {
    if(!_moc) {
        _moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _moc;
}


@end

/*
 
 #pragma mark GameKit delegate
 
 -(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
 {
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 [[app navController] dismissViewControllerAnimated:YES completion:NULL];
 //[[app navController] dismissModalViewControllerAnimated:YES];
 }
 
 -(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
 {
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 [[app navController] dismissViewControllerAnimated:YES completion:NULL];
 //[[app navController] dismissModalViewControllerAnimated:YES];
 }

*/


//-(id) init {
    /*
     // create and initialize a Label
     CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
     
     // ask director for the window size
     CGSize size = [[CCDirector sharedDirector] winSize];
     
     // position the label on the center of the screen
     label.position =  ccp( size.width /2 , size.height/2 );
     
     // add the label as a child to this Layer
     [self addChild: label];
     
     
     
     //
     // Leaderboards and Achievements
     //
     
     // Default font size will be 28 points.
     [CCMenuItemFont setFontSize:28];
     
     // Achievement Menu Item using blocks
     CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
     
     
     GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
     achivementViewController.achievementDelegate = self;
     
     AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
     
     [[app navController] presentModalViewController:achivementViewController animated:YES];
     
     [achivementViewController release];
     }
     ];
     
     // Leaderboard Menu Item using blocks
     CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
     
     
     GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
     leaderboardViewController.leaderboardDelegate = self;
     
     AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
     
     [[app navController] presentModalViewController:leaderboardViewController animated:YES];
     
     [leaderboardViewController release];
     }
     ];
     
     CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
     
     [menu alignItemsHorizontallyWithPadding:20];
     [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
     
     // Add the menu to the layer
     [self addChild:menu];
     */
//}
