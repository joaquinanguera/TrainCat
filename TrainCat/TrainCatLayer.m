//
//  TrainCatLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//

// Import the interfaces
#import "CocosConstants.h"
#import "TrainCatLayer.h"
#import "AppDelegate.h"
#import "GameController.h"

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
#import "BackgroundLayer.h"

// Utils 
#import "RangeArray.h"
#import "NSMutableArray+Extension.h"
#import "NSUserDefaults+Extensions.h"
#import "ArrayUtils.h"
#import "ActionLib.h"
#import "Logger.h"
#import "SoundUtils.h"
#import "CCNode+Extension.h"
#import "CCMenu+Extension.h"

#pragma mark - TrainCatLayer
@interface TrainCatLayer()

@property (nonatomic, strong) NSManagedObjectContext *moc;

@property (nonatomic, strong) StimulusLayer *stim;
@property (nonatomic, strong) GameState *gs;
@property (nonatomic, strong) ResponseLayer *response;
@property (nonatomic, strong) FeedbackLayer *feedback;
@property (nonatomic, strong) BackgroundLayer *bg;

@property (nonatomic, strong) Participant *participant;
@property (nonatomic, strong) NSArray *program;
@property (nonatomic, readonly, strong) StimulusSession *session;
@property (nonatomic, readonly, strong) StimulusCategory *category;
@property (nonatomic, readonly, strong) StimulusBlock *block;
@property (nonatomic, readonly, strong) NSArray *stimuli;
@property (nonatomic, strong) NSString *morphLabel;
@property (nonatomic, assign) NSInteger maxTrials;

@property (nonatomic, assign) SessionType sessionType;

#ifdef DDEBUG
@property (nonatomic, strong) NSArray *aiResponse;
@property (nonatomic, assign) NSInteger aiResponseIndex;
#endif

@end

// HelloWorldLayer implementation
@implementation TrainCatLayer

static NSInteger const kStartMenuTag = 1;

// Helper class method that creates a Scene with the TrainCatLayer as the only child.
+(CCScene *) sceneWithSessionType:(SessionType)sessionType;
{
	CCScene *scene = [CCScene node];
	TrainCatLayer *gameLayer = [[TrainCatLayer alloc] initWithSessionType:sessionType];
	[scene addChild: gameLayer];
	return scene;
}


// on "init" you need to initialize your instance
-(id)initWithSessionType:(SessionType)sessionType {
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
        self.sessionType = sessionType;
        self.maxTrials = (sessionType == SessionTypeNormal) ? kMaxTrialsPerBlock : kMaxTrialsPerPracticeBlock;
        self.bg = [BackgroundLayer node];
        [self addChild:self.bg];
	}
	return self;
}

-(void)onEnterTransitionDidFinish {
    //[getGameController().activityIndicator startAnimating];
    self.gs = self.participant.gameState;
    self.program = [NSKeyedUnarchiver unarchiveObjectWithData:self.participant.program];
    [self startSessionLog];
    [self setSubviews];
    
    // stop the wait animation here
#ifndef DDEBUG
    [self setStartButton];
#else
    self.aiResponse = [ArrayUtils randomBooleansWithCount:self.maxTrials biasForTrue:0.8];
    [self performSelector:@selector(beginGame) withObject:nil afterDelay:kDebugSimulationWaitTime];
#endif    
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
    self.stim = [[StimulusLayer alloc] initWithMaxTrials:self.maxTrials];
    self.stim.delegate = self;
    self.stim.visible = NO;

    self.response = [ResponseLayer node];
    self.response.visible = NO;
    self.response.delegate = self;

    self.feedback = [FeedbackLayer node];
    self.feedback.visible = NO;
    self.feedback.delegate = self;

        
    [self addChild:self.stim];
    [self addChild:self.response];
    [self addChild:self.feedback];
}

-(void)setStartButton {
    CCMenu *mnu = [CCMenu menuWithImagePrefix:@"buttonStart" tag:1 target:self selector:@selector(delayedBeginGame)];
    mnu.tag = kStartMenuTag;
    mnu.opacity = 0;
    [self addChild:mnu];
    [getGameController().activityIndicator stopAnimating];
    [getMenuButton(mnu) runAction:[CCFadeIn actionWithDuration:0.5]];
    [getMenuButton(mnu) runAction:[ActionLib pulse]];
}

-(void)delayedBeginGame {
    [self performSelector:@selector(beginGame) withObject:self afterDelay:0.05];
}

-(void)beginGame {
    [SoundUtils playInputClick];
    self.bg.visible = NO;
    CCNode *mnu = [self getChildByTag:kStartMenuTag];
    [mnu.children.lastObject stopAllActions];
    [self removeChild:mnu cleanup:YES];
    [self setupStimulus];
}

-(void)showStimulus {
    [self.stim clear];
    self.stim.visible = YES;
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
    self.stim.visible = NO;
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
    trial.fixationDuration = self.stim.fixationDuration;
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
    self.bg.visible = YES;
    [self.feedback clear];
    self.feedback.visible = YES;
    [self.feedback showFeedback:gradeCode];
#else
    [self updateStimulus];
#endif
}

-(void)feedbackDidFinish {
    self.feedback.visible = NO;
    self.bg.visible = NO;
    [self updateStimulus];
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

-(void)setupStimulus {
    if([self isGameOver]) {
        segueToScene([SessionCompleteLayer sceneWithParticipant:self.participant sessionId:self.gs.sessionId gameOver:[self isGameOver]]);
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
        if((self.sessionType == SessionTypeNormal) && ([self isGameOver] || [self isSessionComplete])) {
            scene = [SessionCompleteLayer sceneWithParticipant:self.participant sessionId:self.gs.sessionId gameOver:[self isGameOver]];
        } else { // SessionTypeWarmup or SessionTypePractice or SessionTypeNormal but !isGameOver && !isSessionComplete
            scene = [BlockCompleteLayer sceneWithParticipant:self.participant sessionType:self.sessionType];
        }
        
        segueToScene(scene);
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
    NSInteger cBlockId = [self.session.blocks[self.gs.blockId] intValue];
    return self.category.blocks[cBlockId];
}

-(NSArray *)stimuli {
    StimulusList *list = self.block.lists[self.gs.listId];
    return list.stimuli;
}

-(Participant *)participant {
    if(!_participant) {
        if(self.sessionType == SessionTypeNormal) {
            _participant = [Participant participantWithId:[[NSUserDefaults standardUserDefaults] loggedIn] mustExist:YES];
        } else {
            _participant = [Participant dummyParticipant];
        }
    }
    
    return _participant;
}

-(NSManagedObjectContext *) moc {
    if(!_moc) {
        _moc = getMOC();
    }
    return _moc;
}


@end


