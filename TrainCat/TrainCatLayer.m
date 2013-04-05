//
//  TrainCatLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
#import "constants.h"
#import "TrainCatLayer.h"
#import "AppDelegate.h"

// Core data
#import "Participant+Extension.h"
#import "SessionLog+Extension.h"
#import "Session+Extension.h"
#import "Block+Extension.h"
#import "GameState.h"
#import "Trial.h"


// Game Data
#import "StimulusPack.h"
#import "StimulusSession.h"
#import "StimulusCategory.h"
#import "StimulusBlock.h"
#import "StimulusList.h"

// UI Layers
#import "HUDLayer.h"
#import "StimulusLayer.h"
#import "ResponseLayer.h"
#import "FeedbackLayer.h"
#import "SessionCompleteLayer.h"
#import "BlockCompleteLayer.h"
#import "GameOverLayer.h"

// Utils 
#import "RangeArray.h"
#import "NSMutableArray+Extension.h"
#import "NSUserDefaults+Extensions.h"
#import "ArrayUtils.h"
#import "ActionLib.h"
#import "Logger.h"


#pragma mark - TrainCatLayer
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
@property (nonatomic, assign) int maxTrials;

@property (nonatomic, assign) BOOL isPractice;

#ifdef DDEBUG
@property (nonatomic, strong) NSArray *aiResponse;
@property (nonatomic, assign) int aiResponseIndex;
#endif

@end

// HelloWorldLayer implementation
@implementation TrainCatLayer

// Helper class method that creates a Scene with the TrainCatLayer as the only child.
+(CCScene *) sceneWithPracticeSetting:(BOOL)isPractice
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TrainCatLayer *gameLayer = [[TrainCatLayer alloc] initWithPracticeSetting:isPractice];
    
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
-(id)initWithPracticeSetting:(BOOL)isPractice {
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) { // ccc4(220, 220, 220, 255)
        self.isPractice = isPractice;
        
        self.maxTrials = isPractice ? MAX_TRIALS_PER_PRACTICE_BLOCK : MAX_TRIALS_PER_STIMULUS_BLOCK;
        self.gs = self.participant.gameState;
        self.program = [NSKeyedUnarchiver unarchiveObjectWithData:self.participant.program];
        
        [self startSessionLog];
        [self setSubviews];
        
        #ifndef DDEBUG
         [self setStartButton];
        #else
         self.aiResponse = [ArrayUtils aiYesNoResponsesWithTrialCount:self.maxTrials expectedAccuracyPercentage:1.0];
         NSLog(@"Responses = [%@]", [self.aiResponse componentsJoinedByString:@","]);
         [self performSelector:@selector(beginGame) withObject:nil afterDelay:DEBUG_SIMULATION_WAIT_TIME];
        #endif
	}
	return self;
}

-(id) init
{
    return [self initWithPracticeSetting:NO];
}

-(void)startSessionLog {
    SessionLog *session = [NSEntityDescription insertNewObjectForEntityForName:@"SessionLog" inManagedObjectContext:self.moc];
    session.sid = self.gs.sessionId;
    session.participant = self.participant; // Do we need to do this?
    [self.participant addSessionLogsObject:session];
}

-(void)endSessionLog {
    SessionLog *session = self.participant.sessionLogs.lastObject;
    session.endTime = [NSDate date];
}

-(void)setSubviews {
    // Note: We could do this in the 'sceneWithPracticeSetting' but this layer is useless by itself
    // so we construct the other layers in init.
    self.stim = [StimulusLayer node];
    self.stim.delegate = self;
    
    self.response = [ResponseLayer node];
    self.response.delegate = self;
    self.response.visible = NO;
    
    self.feedback = [FeedbackLayer node];
    self.feedback.delegate = self;
    self.feedback.visible = NO;
    
    self.hud = [HUDLayer node];
    [self addChild:self.stim];
    [self addChild:self.response];
    [self addChild:self.feedback];
    [self addChild:self.hud];    
}

-(void)setStartButton {
    CCMenuItemImage *btnStart = [CCMenuItemImage itemWithNormalImage:@"buttonStartNormal.png" selectedImage:@"buttonStartSelected.png" target:self selector:@selector(beginGame)];
    CCMenu *mnu = [CCMenu menuWithItems:btnStart,nil];
    mnu.tag = START_MENU_TAG;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mnu];
    [btnStart runAction:[ActionLib pulse]];    
}

-(void)beginGame {
    CCNode *mnu = [self getChildByTag:START_MENU_TAG];
    [mnu.children.lastObject stopAllActions];
    [self removeChild:mnu cleanup:YES];
    [self setupStimulus];
}

-(void)showStimulus {
    [self.stim clear];
    self.morphLabel = self.stimuli[arc4random() % self.stimuli.count];
#ifndef DDEBUG
    [self.stim showStimulusWithExemplarLeftPath:self.category.exemplarLeft exemplarRightPath:self.category.exemplarRight morphLabel:self.morphLabel];
#else
    BOOL airesp = [self.aiResponse[self.aiResponseIndex] boolValue];
    ResponseType correctResponse = [self getCorrectResponseFromMorphLabel:self.morphLabel];
    self.aiResponseIndex++;
    [self grade:(airesp ? correctResponse : correctResponse == ResponseTypeLeft ? ResponseTypeRight : ResponseTypeLeft) responseTime:0];
#endif
}

-(void)stimulusDidFinish {
    [self.response clear];
    self.response.visible = YES;
    [self.response getResponse];
}

-(void)didRespond:(ResponseType)response responseTime:(NSTimeInterval)responseTime {
    self.response.visible = NO;
    [self grade:response responseTime:responseTime];
}

-(void)grade:(ResponseType)response responseTime:(NSTimeInterval)responseTime {
    GradeType gradeCode = (response == [self getCorrectResponseFromMorphLabel:self.morphLabel]) ? GradeTypeCorrect : (response == ResponseTypeNoResponse) ? GradeTypeNoResponse : GradeTypeIncorrect;
    
    // log trial
    self.gs.trialCount++;
    Trial *trial = [self createTrial];
    trial.listId = self.gs.listId; 
    trial.trial = self.gs.trialCount; 
    trial.categoryId = self.session.categoryId; 
    trial.exemplars = [NSString stringWithFormat:@"%@ / %@", self.category.exemplarLeft, self.category.exemplarRight];
    trial.morphLabel = self.morphLabel;
    trial.responseTime = responseTime;
    
    if(gradeCode == GradeTypeCorrect) self.gs.listId = min(self.block.lists.count-1, self.gs.listId+1);
    else self.gs.listId = max(0, self.gs.listId-2);
    
    switch(response) {
        case ResponseTypeLeft:
            trial.response = @"Left";
            break;
        case ResponseTypeRight:
            trial.response = @"Right";
            break;
        case ResponseTypeNoResponse:
            trial.response = @"No Response";
            break;
    }
    
    switch(gradeCode) {
        case GradeTypeCorrect:
            trial.accuracy = @"Correct";
            break;
        case GradeTypeIncorrect:
            trial.accuracy = @"Incorrect";
            break;
        case GradeTypeNoResponse:
            trial.accuracy = @"No Response";
            break;
    }
    
    [self endSessionLog];
    [self saveContext];
    
    //NSLog(@"%@", trial);
#ifndef DDEBUG
    [self.feedback clear];
    self.feedback.visible = YES;
    [self.feedback showFeedback:gradeCode];
#else
    [self updateStimulus];
#endif
}

-(Trial *)createTrial {
    Session *session;
    Block *block;
    
    if((self.gs.sessionId+1) > self.participant.sessions.count) {
        if((self.gs.sessionId+1 - self.participant.sessions.count)!=1) {
            NSLog(@"Game state says we should have %d sessions. We have only %d.", self.gs.sessionId+1, self.participant.sessions.count);
            abort();
        }
        session = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:self.moc];
        session.sid = self.gs.sessionId;
        session.participant = self.participant;
        [self.participant addSessionsObject:session];
    } else {
        session = [self.participant.sessions lastObject];
    }

    if((self.gs.blockId+1) > session.blocks.count) {
        if((self.gs.blockId+1 - session.blocks.count)!=1) {
            NSLog(@"Game state says we should have %d blocks. We have only %d.", self.gs.blockId+1, session.blocks.count);
            abort();
        }
        block = [NSEntityDescription insertNewObjectForEntityForName:@"Block" inManagedObjectContext:self.moc];
        block.bid = [self.session.blocks[self.gs.blockId] intValue]; // This is the block ID as per the Stimulus pack (0..5). 
        block.session = session;
        [session addBlocksObject:block];
    } else {
        block = [session.blocks lastObject];
    }
    
    Trial *trial = [NSEntityDescription insertNewObjectForEntityForName:@"Trial" inManagedObjectContext:self.moc];
    trial.block = block;
    [block addTrialsObject:trial];
    return trial;
}

-(void)feedbackDidFinish {
    self.feedback.visible = NO;
    [self updateStimulus];
}


-(void)setupStimulus {
    if([self isGameOver]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[GameOverLayer scene]]];
    } else {
        // Did we finish the last block?
        if(self.gs.trialCount >= self.maxTrials)  {
            // If we did finish the last block, is there a new block in the same session?
            if(self.gs.blockId < (self.session.blocks.count-1)) {
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
        
        [self saveContext];
        [self showStimulus];
    }
}

-(void)updateStimulus {
    // Are there more trials left?
    if(self.gs.trialCount < self.maxTrials) {
        // If yes, continue displaying trials
        [self showStimulus];
    } else {
        // If no more trials are pending
        // Transition to next screen
        CCScene *scene;
        if([self isGameOver]) {
#ifdef DDEBUG
            [Logger printBlocksForParticipant:self.participant];
            [Logger printSessionLogsForParticipant:self.participant];
            NSLog(@"Perf = %@", [[self.participant performanceData] componentsJoinedByString:@","]);
            //[Participant clearStateForParticipantWithId:[SessionManager loggedIn]];
#endif
            scene = [GameOverLayer scene]; 
        } else if([self isSessionComplete]){
            scene = [SessionCompleteLayer scene];
        } else {
            scene = [BlockCompleteLayer scene];
        }
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    }
}

-(BOOL)isSessionComplete {
    return ((self.gs.blockId >= (self.session.blocks.count - 1)) /* last block in the session */ && (self.gs.trialCount >= self.maxTrials) /* all trials complete */);
}

-(BOOL)isGameOver {
    return ((self.gs.sessionId >= (self.program.count-1)) /* last session in the program */ && [self isSessionComplete]);
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

-(void)saveContext {
    [((AppController *)[[UIApplication sharedApplication] delegate]) saveContext];    
}


#pragma mark Properties
-(SessionLog *)session {
    return self.program[self.gs.sessionId];
}

-(StimulusCategory *)category {
    return [StimulusPack sessions][self.session.categoryId];
}

-(StimulusBlock *)block {
    int cBlockId = [self.session.blocks[self.gs.blockId] intValue];
    return self.category.blocks[cBlockId];
}

-(NSArray *)stimuli {
    StimulusList *list = self.block.lists[self.gs.listId];
    return list.stimuli;
}

-(Participant *)participant {
    if(!_participant) {
        if(self.isPractice) {
            _participant = [Participant dummyParticipant];
        } else {
            _participant = [Participant participantWithId:[[NSUserDefaults standardUserDefaults] loggedIn] mustExist:YES];
        }
    }
    return _participant;
}


-(NSManagedObjectContext *) moc {
    if(!_moc) {
        _moc = MOC;
    }
    return _moc;
}


@end


