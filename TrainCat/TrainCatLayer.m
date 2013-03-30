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
#import "Session+Extension.h"
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
#import "HUDLayer.h"
#import "SessionCompleteLayer.h"
#import "GameOverLayer.h"
#import "Trial.h"

#pragma mark - HelloWorldLayer
@interface TrainCatLayer()
@property (nonatomic, strong) NSManagedObjectContext *moc;

@property (nonatomic, strong) StimulusLayer *stim;
@property (nonatomic, strong) GameState *gs;
@property (nonatomic, strong) ResponseLayer *response;
@property (nonatomic, strong) FeedbackLayer *feedback;
@property (nonatomic, strong) HUDLayer *hud;

@property (nonatomic, strong) Participant *participant;
@property (nonatomic, strong) NSArray *program;
@property (nonatomic, readonly, strong) StimulusSession *session;
@property (nonatomic, readonly, strong) StimulusCategory *category;
@property (nonatomic, readonly, strong) StimulusBlock *block;
@property (nonatomic, readonly, strong) NSArray *stimuli;
@property (nonatomic, strong) NSString *morphLabel;
@property (nonatomic, strong) Trial *trial;

@end

// HelloWorldLayer implementation
@implementation TrainCatLayer

// Helper class method that creates a Scene with the TrainCatLayer as the only child.
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
        
        self.hud = [[HUDLayer alloc] init];
        
        [self addChild:self.stim];
        [self addChild:self.response];
        [self addChild:self.feedback];
        [self addChild:self.hud];
        
        [self performSelector:@selector(beginGame) withObject:nil afterDelay:2.0];
	}
	return self;
}

-(void)beginGame {
    //[self clearState]; // TODO: Debug
    [self setupStimulusWithNewSession:YES];
}

-(void)showStimulus {
    self.morphLabel = self.stimuli[arc4random() % self.stimuli.count];
    //[self.stim showStimulusWithExemplarLeftPath:self.category.exemplarLeft exemplarRightPath:self.category.exemplarRight morphLabel:self.morphLabel];
    [self grade:[self getCorrectResponseFromMorphLabel:self.morphLabel]]; // TODO: Debug
    
}

-(void)stimulusDidFinish {    
    self.response.visible = YES;
    [self.response getResponse];
}

-(void)didRespond:(ResponseType)response {
    self.response.visible = NO;
    [self grade:response];
}

-(void)grade:(ResponseType)response {
    GradeType gradeCode = (response == [self getCorrectResponseFromMorphLabel:self.morphLabel]) ? GradeTypeCorrect : (response == ResponseTypeNoResponse) ? GradeTypeNoResponse : GradeTypeIncorrect;
    
    // log trial
    self.gs.trialCount++;
    self.trial = [NSEntityDescription insertNewObjectForEntityForName:@"Trial" inManagedObjectContext:self.moc];
    self.trial.participant = self.participant;
    self.trial.sessionId = self.gs.sessionId;
    self.trial.blockId = self.gs.blockId;
    self.trial.listId = self.gs.listId+1; // Level is indexed from 1 in the report
    self.trial.trial = self.gs.trialCount; 
    self.trial.categoryId = self.session.categoryId;
    self.trial.exemplars = [NSString stringWithFormat:@"%@ / %@", self.category.exemplarLeft, self.category.exemplarRight];
    self.trial.morphLabel = self.morphLabel;
    if(gradeCode == GradeTypeCorrect) self.gs.listId = min(self.block.lists.count-1, self.gs.listId+1);
    else self.gs.listId = max(0, self.gs.listId-2);
    
    switch(response) {
        case ResponseTypeLeft:
            self.trial.response = @"Left";
            break;
        case ResponseTypeRight:
            self.trial.response = @"Right";
            break;
        case ResponseTypeNoResponse:
            self.trial.response = @"No Response";
            break;
    }
    
    switch(gradeCode) {
        case GradeTypeCorrect:
            self.trial.accuracy = @"Correct";
            break;
        case GradeTypeIncorrect:
            self.trial.accuracy = @"Incorrect";
            break;
        case GradeTypeNoResponse:
            self.trial.accuracy = @"No Response";
            break;
    }
    
    [self saveState];
    
    
    // show feedback
    //[self.feedback clear];
    //self.feedback.visible = YES;
    //[self.feedback showFeedback:gradeCode];
    [self feedbackDidFinish]; // Debug
}

-(void)feedbackDidFinish {
    self.feedback.visible = NO;    
    [self printGameState];
    [self updateStimulus];
}


-(void)setupStimulusWithNewSession:(BOOL)newSession {
    if([self isGameOver]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene] withColor:ccWHITE]];
    } else {
        // Did we finish the last block?
        if(self.gs.trialCount >= MAX_TRIALS_PER_STIMULUS_BLOCK)  {
            // If we did finish the last block, is there a new block in the same session?
            if(self.gs.blockId < (self.category.blocks.count-1)) {
                // If yes, move to the next block
                self.gs.blockId++;
                self.gs.listId = 0;
                self.gs.trialCount = 0;
            }
            else {
                // If there is no block remaining in the current session, move to the next session
                // (note - we've already tested for no new sessions remaining ie game over)
                self.gs.sessionId++;
                self.gs.blockId = 0;
                self.gs.listId = 0;
                self.gs.trialCount = 0;
            }
        }
        
        if(newSession) {
            Session *session = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:self.moc];
            session.sid = self.gs.sessionId;
            session.participant = self.participant; // Do we need to do this?
            [self.participant addSessionsObject:session];
        }
        [self saveState];
        [self showStimulus];
    }
}

-(void)updateStimulus {
    // Are there more trials left?
    if(self.gs.trialCount < MAX_TRIALS_PER_STIMULUS_BLOCK) {
        // If yes, continue displaying trials
        [self showStimulus];
    } else {
        // If no more trials are pending
        // Print the block
        //[self printBlock:self.gs.blockId inCategory:self.session.categoryId inSession:self.gs.sessionId]; // TODO: Debug
        // Do we have another block to turn to in this session?
        if(self.gs.blockId < (self.category.blocks.count-1)) {
            // If yes, setup stimulus but without creating a new session
            [self setupStimulusWithNewSession:NO];
        } else {
            // If no, session is complete
            // Transition to next screen
            Session *session = self.participant.sessions.lastObject;
            session.endTime = [NSDate date];
            [self saveState];
            
            // TODO: Debug
            if([self isGameOver]) {
                [self printAllBlocks];
                [self printAllSessions];
            }
            
            CCScene *scene = [self isGameOver] ? [GameOverLayer scene] : [SessionCompleteLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccWHITE]];
        }
    }
}

-(BOOL)isGameOver {
    return ((self.gs.sessionId >= (self.program.count-1)) && (self.gs.blockId >= (self.category.blocks.count-1)) && (self.gs.trialCount >= MAX_TRIALS_PER_STIMULUS_BLOCK)); // TODO: Debug:
}

-(ResponseType)getCorrectResponseFromMorphLabel:(NSString *)morph {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:nil error:nil];
    NSArray *matches = [regex matchesInString:morph options:0 range:NSMakeRange(0, [morph length])];
    ResponseType correctResponse = ResponseTypeNoResponse;
    
    if(matches.count) {
        NSTextCheckingResult *match = [matches lastObject];
        NSRange matchRange = [match range];
        NSString *stimTag = [morph substringWithRange:matchRange];
        correctResponse = ([stimTag integerValue] <= 50) ? ResponseTypeLeft:ResponseTypeRight;
    } else {
        // This really shouldn't happen!
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Fatal error"
                                                          message:@"Stimulus label is invalid. Contact the developer."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    return correctResponse;
}

-(void)saveState {
    NSError *error = nil;
    if (![self.moc save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"%@", error);
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain]
                                                          message:@"Failed to save the game progress! Contact the developer." /* , [error userInfo] */
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    NSLog(@"Saved state.");
}

#pragma mark Properties
-(Session *)session {
    return self.program[self.gs.sessionId];
}

-(StimulusCategory *)category {
    return [StimulusPack sessions][self.session.categoryId];
}

-(StimulusBlock *)block {
    return self.category.blocks[self.gs.blockId];
}

-(NSArray *)stimuli {
    StimulusList *list = self.block.lists[self.gs.listId];
    return list.stimuli;
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
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain] /* , [error userInfo] */
                                                              message:@"There was an error reading the Participant database. Contact the developer."
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


-(NSManagedObjectContext *) moc {
    if(!_moc) {
        _moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _moc;
}


#pragma mark Debug functions
-(void)printBlock:(int)blockId inCategory:(int)categoryId inSession:(int)sessionId {
    NSLog(@"%@", [[NSArray arrayWithObjects:@"Session Id", @"Category Id", @"Block Id", @"Trial", @"Exemplars", @"Morph Level", @"Morph Stimulus", @"RT", @"Response", @"Accuracy", nil] componentsJoinedByString:@","]);
    for(Trial *trial in self.participant.trials) {
        if(trial.blockId == blockId && trial.sessionId == sessionId && trial.categoryId == categoryId) {
            NSLog(@"%@", [[NSArray arrayWithObjects:[NSNumber numberWithInt:trial.sessionId], [NSNumber numberWithInt:trial.categoryId], [NSNumber numberWithInt:trial.blockId], [NSNumber numberWithInt:trial.trial], trial.exemplars, [NSNumber numberWithInt:trial.listId], trial.morphLabel, [NSNumber numberWithInt:trial.responseTime], trial.response, trial.accuracy, nil] componentsJoinedByString:@","]);
        }
    }
}

-(void)printAllBlocks {
    int count = 0;
    NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", @"#", @"Session Id", @"Category Id", @"Block Id", @"Trial", @"Exemplars", @"Morph Level", @"Morph Stimulus", @"RT", @"Response", @"Accuracy", nil] componentsJoinedByString:@","]);
    for(Trial *trial in self.participant.trials) {
        NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", [NSNumber numberWithInt:++count], [NSNumber numberWithInt:(trial.sessionId+1)], [NSNumber numberWithInt:trial.categoryId], [NSNumber numberWithInt:trial.blockId], [NSNumber numberWithInt:trial.trial], trial.exemplars, [NSNumber numberWithInt:trial.listId], trial.morphLabel, [NSNumber numberWithInt:trial.responseTime], trial.response, trial.accuracy, nil] componentsJoinedByString:@","]);

    }    
}

-(void)printAllSessions {
    int count = 0;
    NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", @"#", @"Session Id", @"startTime", @"endTime", nil] componentsJoinedByString:@","]);
    for (Session *session in self.participant.sessions) {
        NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", [NSNumber numberWithInt:++count], [NSNumber numberWithInt:(session.sid+1)], [self stringFromDate:session.startTime], [self stringFromDate:session.endTime], nil] componentsJoinedByString:@","]);
    }
}

-(void)clearState {
    [self.moc deleteObject:self.participant];
    _participant = nil;
    self.gs = self.participant.gameState;
    self.program = [NSKeyedUnarchiver unarchiveObjectWithData:self.participant.program];
}

-(NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm a";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+05:30"];
    [dateFormatter setTimeZone:gmt];
    return [dateFormatter stringFromDate:date];
}

-(void)printGameState {
    GameState *gs = self.participant.gameState;
    NSLog(@"GameState = [Session Id: %d, CategoryID:%d, BlockID:%d, ListID:%d, TrialCount:%d]", gs.sessionId, self.session.categoryId, gs.blockId, gs.listId, gs.trialCount);
}


-(void)printStimulusPack {
    NSArray *stim = [StimulusPack sessions];
    for(StimulusCategory *cat in stim) {
        NSLog(@"%@", cat);
    }
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
