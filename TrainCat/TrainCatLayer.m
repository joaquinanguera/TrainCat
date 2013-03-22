//
//  HelloWorldLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
#import "TrainCatLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "StimulusPack.h"
#import "StimulusCategory.h"
#import "StimulusBlock.h"
#import "StimulusList.h"
#import "RangeArray.h"
#import "NSMutableArray+Shuffling.h"
#import "TrainCatProgram.h"
#import "TrainCatSession.h"

#pragma mark - HelloWorldLayer

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
	if( (self=[super initWithColor:ccc4(220, 220, 220, 255)]) ) {
        CCSprite *sprite = [CCSprite spriteWithFile:@"Icon.png"];
        sprite.position = ccp(300, 300);
        [self addChild:sprite];
        [self printStimulusPack];
        [self makeTrainCatProgram];
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

	}
	return self;
}

-(void)printStimulusPack {
    NSArray *stim = [StimulusPack categories];
    for(StimulusCategory *cat in stim) {
        NSLog(@"%@", cat);
    }    
}

-(void)makeTrainCatProgram {
    NSArray *stim = [StimulusPack categories];
    NSMutableArray *categories = [[[RangeArray alloc] initWithRangeFrom:0 to:stim.count-1] mutableCopy];
    [categories shuffle];
    NSMutableArray *categorySequence = [categories mutableCopy];
    [categories shuffle];
    [categorySequence addObjectsFromArray:categories];
    
    NSNumber *zero = [NSNumber numberWithInt:0];
    NSNumber *one = [NSNumber numberWithInt:1];
    NSMutableArray *blocks = [NSMutableArray arrayWithObjects:zero,zero,zero,one,one,one, nil];
    
    TrainCatProgram *program = [[TrainCatProgram alloc] init];
    for(NSNumber *catID in categorySequence) {
        [blocks shuffle];
        [program.sessions addObject:[[TrainCatSession alloc] initWithCategoryID:catID blocks:[blocks mutableCopy]]];
    }    
    
    NSLog(@"%@", [categorySequence componentsJoinedByString:@","]);
    NSLog(@"%@", [blocks componentsJoinedByString:@","]);
    NSLog(@"%@", program);
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
@end
