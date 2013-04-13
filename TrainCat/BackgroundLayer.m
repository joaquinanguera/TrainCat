//
//  BackgroundLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "CocosConstants.h"
#import "CCNode+Extension.h"

@implementation BackgroundLayer
// Helper class method that creates a Scene with the BackgroundLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BackgroundLayer *gameLayer = [BackgroundLayer node];
    
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:getCocosBackgroundColor()]) ) {
        [self addChild:[[[[CCSprite spriteWithSpriteFrameName:@"logoTrainCat.png"] alignBottom] alignCenter] shiftDown:2.0]];
    }
    return self;
}


@end
