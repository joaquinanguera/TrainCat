//
//  SessionCompleteLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "SessionCompleteLayer.h"
#import "TrainCatLayer.h"


@implementation SessionCompleteLayer

// Helper class method that creates a Scene with the SessionComplete as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SessionCompleteLayer *gameLayer = [SessionCompleteLayer node];
	
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Session Complete!" fontName:GAME_TEXT_FONT fontSize:64];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(winSize.width/2.0,winSize.height/2.0);
        [self addChild:label];
        
        CCMenuItemImage *btnNewSessionImage = [CCMenuItemImage itemWithNormalImage:@"buttonNewSessionNormal.png" selectedImage:@"buttonNewSessionSelected.png" target:self selector:@selector(didTapNewSession)];
        CCMenu *btnNewSession = [CCMenu menuWithItems:btnNewSessionImage,nil];
        btnNewSession.position = ccp(winSize.width/2.0,label.position.y - label.contentSize.height/2 - btnNewSessionImage.contentSize.height/2 - 50);
        [self addChild:btnNewSession];
    }
#ifdef DDEBUG
    [self performSelector:@selector(didTapNewSession) withObject:nil afterDelay:DEBUG_SIMULATION_WAIT_TIME];
#endif
    return self;
}

-(void)didTapNewSession {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TrainCatLayer sceneWithPractice:NO] withColor:ccWHITE]];
}

@end
