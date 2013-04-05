//
//  IntroLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
#import "IntroLayer.h"
#import "TrainCatLayer.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "TrainCatLayer.h"
#import "GameController.h"
#import "Participant+Extension.h"
#import "SpriteUtils.h"
#import "CCMenu+Extensions.h"

#pragma mark - IntroLayer


// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:BACKGROUND_COLOR]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background];
    }
    return self;
}

-(void) onEnter
{
	[super onEnter];
    [self makeMenu];
}

-(void)makeMenu {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSArray *buttonPrefixs = [[NSArray alloc] initWithObjects:@"buttonPlay", @"buttonPractice", @"buttonSettings", nil];
    NSArray *buttonSelectors = [[NSArray alloc] initWithObjects:@"didTapPlay:", @"didTapPractice:", @"didTapSettings:", nil];
    
    // TODO: Ensure that we have at least ONE currently logged in user (other than Demo)
    CCMenu *mnu = [CCMenu menuWithImagePrefixes:buttonPrefixs tags:nil target:self selectors:buttonSelectors];
    [mnu alignItemsVerticallyWithPadding:30];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    
    CCMenu *mnuToggleSound = [CCMenu menuWithImagePrefix:@"iconSpeaker" tag:0 target:self selector:@selector(didTapToggleBackgroundMusic:)];
    mnuToggleSound.position = ccp(winSize.width - mnuToggleSound.button.contentSize.width/2 - STIMULUS_PADDING, mnuToggleSound.button.contentSize.height/2 + STIMULUS_PADDING);
    
    [self addChild:mnu];
    [self addChild:mnuToggleSound];
}

-(void)didTapPlay:(CCMenuItem *)menuItem {
#ifdef DDEBUG
    //[Participant clearStateForParticipantWithId:[SessionManager loggedIn]];
    
#endif
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPracticeSetting:NO]]];    
}

-(void)didTapPractice:(CCMenuItem *)menuItem {
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPracticeSetting:YES]]];    
}

-(void)didTapSettings:(CCMenuItem *)menuItem {
    GameController *gc = (GameController *)([CCDirector sharedDirector].delegate);
    [gc performSegueWithIdentifier:@"segueToSettingsAuthentication" sender:gc];
}


-(void)didTapToggleBackgroundMusic:(CCMenuItem *)menuItem {
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        ((CCMenuItemImage *)menuItem).opacity = 128;
    } else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"POL-slums-of-rage-short.wav"]; // Currently throwing an error
        ((CCMenuItemImage *)menuItem).opacity = 255;
    }
}

-(void)onExit {
    //[self didTapToggleBackgroundMusic];
    [super onExit];
}

@end
