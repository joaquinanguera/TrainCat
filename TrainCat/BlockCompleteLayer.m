//
//  BlockCompleteLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "BlockCompleteLayer.h"
#import "TrainCatLayer.h"
#import "SimpleAudioEngine.h"
#import "BackgroundLayer.h"

#define kBlockCompleteEffect @"blockComplete.mp3"

@implementation BlockCompleteLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BlockCompleteLayer *gameLayer = [BlockCompleteLayer node];
	
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:kBlockCompleteEffect];
        
        [self addChild:[BackgroundLayer node]];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Block Complete!" fontName:GAME_TEXT_FONT fontSize:64];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(winSize.width/2.0,winSize.height/2.0);
        [self addChild:label];
        
        CCMenuItemImage *btnContinueImage = [CCMenuItemImage itemWithNormalImage:@"buttonContinueNormal.png" selectedImage:@"buttonContinueSelected.png" target:self selector:@selector(didTapContinue)];
        CCMenu *btnContinue = [CCMenu menuWithItems:btnContinueImage,nil];
        btnContinue.position = ccp(winSize.width/2.0,label.position.y - label.contentSize.height/2 - btnContinueImage.contentSize.height/2 - 50);
        [self addChild:btnContinue];
    }
    
#ifdef DDEBUG
    [self performSelector:@selector(didTapContinue) withObject:nil afterDelay:DEBUG_SIMULATION_WAIT_TIME];
#endif
    return self;
}

-(void)onEnter {
    [[SimpleAudioEngine sharedEngine] playEffect:kBlockCompleteEffect];
}

-(void)didTapContinue {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TrainCatLayer sceneWithPractice:NO] withColor:ccWHITE]];
}


@end
