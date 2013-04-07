//
//  GameOverLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "GameOverLayer.h"
#import "constants.h"

@implementation GameOverLayer

// Helper class method that creates a Scene with the GameOverLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *gameLayer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over!" fontName:GAME_TEXT_FONT fontSize:64];
        label.color = ccc3(0, 0, 0);
        label.position = ccp( winSize.width /2 , winSize.height/2 );
        [self addChild:label];
    }
    
    return self;
}


@end
