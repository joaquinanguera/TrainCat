//
//  HelloWorldLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
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
#import "GameState.h"

#pragma mark - HelloWorldLayer
@interface TrainCatLayer()
@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) Participant *participant;
@property (nonatomic, strong) NSArray *program;
@end

// HelloWorldLayer implementation
@implementation TrainCatLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TrainCatLayer *layer = [TrainCatLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) { // ccc4(220, 220, 220, 255)
        if(self.participant) {
            self.program = [NSKeyedUnarchiver unarchiveObjectWithData:self.participant.program];
            [self beginGame];
        } else {
            NSLog(@"Insert a participant with ID 0 and restart");
        }
	}
	return self;
}


-(void)beginGame {
    // TODO: Test if the game is already over
    GameState *gs = self.participant.gameState;
    NSArray *sessions = [StimulusPack sessions];
    StimulusSession *session = self.program[gs.sessionID];
    StimulusCategory *category = sessions[session.categoryID];
    StimulusBlock *block = category.blocks[gs.blockID];
    StimulusList *list = block.lists[gs.listID];
    NSArray *stimuli = list.stimuli;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //int minY = monster.contentSize.height/2;
    //int maxY = winSize.height - monster.contentSize.height/2;
    //int rangeY = maxY - minY;
    //int actualY = (arc4random() % rangeY) + minY;
    
    
    
    // Fixation
    
    // Exemplar
    CCSprite *el = [CCSprite spriteWithFile:category.exemplarLeft];
    el.position = ccp(300, 600);
    [self addChild:el];
    
    CCSprite *er = [CCSprite spriteWithFile:category.exemplarRight];
    er.position = ccp(700, 600);
    [self addChild:er];
    
    
    // Mask
    
    // Morph
    
    // Response
    
    // Feedback
    
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
}

-(void)printGameState {
    GameState *gs = self.participant.gameState;
    NSLog(@"GameState = [CategoryID:%d, BlockID:%d, ListID:%d, TrialCount:%d]", gs.sessionID, gs.blockID, gs.listID, gs.trialCount);
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
            // Deal with the error
        } else if(!array.count) {
            // Insert a default participant
        } else {
            _participant = array[0];
        }
        
    }
    return _participant;
}

-(void)printStimulusPack {
    NSArray *stim = [StimulusPack sessions];
    for(StimulusCategory *cat in stim) {
        NSLog(@"%@", cat);
    }    
}


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

-(NSManagedObjectContext *) moc {
    if(!_moc) {
        _moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _moc;
}


@end


//-(id) init {
    //CCSprite *sprite = [CCSprite spriteWithFile:@"Icon.png"];
    //sprite.position = ccp(300, 300);
    //[self addChild:sprite];
    //[self printStimulusPack];
    //[self makeTrainCatProgram];
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
