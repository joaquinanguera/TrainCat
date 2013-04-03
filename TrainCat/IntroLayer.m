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
#import "SessionManager.h"
#import "Participant+Extension.h"

#pragma mark - IntroLayer

typedef NS_ENUM(NSInteger, MainMenuButtonActionType) {
    MainMenuButtonActionTypePlay,
    MainMenuButtonActionTypePractice,
    MainMenuButtonActionTypeSettings
};


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
    if( (self=[super initWithColor:ccc4(56, 191, 218, 255)]) ) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"POL-slums-of-rage-short.wav"]; // Currently throwing an error
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
    
    // TODO: Ensure that we have at least ONE currently logged in user (other than Demo)
    CCMenuItemImage *btnPlay = [CCMenuItemImage itemWithNormalImage:@"buttonPlayNormal.png" selectedImage:@"buttonPlaySelected.png" target:self selector:@selector(didRespond:)];
    btnPlay.tag = MainMenuButtonActionTypePlay;
    
    CCMenuItemImage *btnPractice = [CCMenuItemImage itemWithNormalImage:@"buttonPracticeNormal.png" selectedImage:@"buttonPracticeSelected.png" target:self selector:@selector(didRespond:)];
    btnPractice.tag = MainMenuButtonActionTypePractice;
    
    CCMenuItemImage *btnSettings = [CCMenuItemImage itemWithNormalImage:@"buttonSettingsNormal.png" selectedImage:@"buttonSettingsSelected.png" target:self selector:@selector(didRespond:)];
    btnSettings.tag = MainMenuButtonActionTypeSettings;
    
    CCMenu *mnu = [CCMenu menuWithItems:btnPlay,btnPractice,btnSettings,nil];
    [mnu alignItemsVerticallyWithPadding:30];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    
    [self addChild:mnu];
}


-(void)didRespond:(CCMenuItem *)menuItem {    
    GameController *gc;
    
    switch(menuItem.tag) {
        case MainMenuButtonActionTypePlay:
#ifdef DEBUG
            [Participant clearStateForParticipantWithId:[SessionManager loggedIn]];
            
#endif
            [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPracticeSetting:NO]]];
            break;
        case MainMenuButtonActionTypePractice:
            NSLog(@"Switching to practice mode.");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPracticeSetting:YES]]];
            break;
        case MainMenuButtonActionTypeSettings:
            gc = (GameController *)([CCDirector sharedDirector].delegate);
            [gc performSegueWithIdentifier:@"segueToSettingsAuthentication" sender:gc];

            //[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneW]]];
            break;
        default:
            NSLog(@"Unrecognized tag %d", menuItem.tag);
            break;
    }
    
}

-(void)onExit {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [super onExit];
}

@end
