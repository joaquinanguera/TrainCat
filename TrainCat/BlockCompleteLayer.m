//
//  BlockCompleteLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BlockCompleteLayer.h"
#import "TrainCatLayer.h"

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
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Block Complete!" fontName:@"DevanagariSangamMN-Bold" fontSize:64];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(winSize.width/2.0,winSize.height/2.0);
        [self addChild:label];
        
        CCMenuItemImage *btnContinueImage = [CCMenuItemImage itemWithNormalImage:@"buttonContinueNormal.png" selectedImage:@"buttonContinueSelected.png" target:self selector:@selector(didTapContinue)];
        CCMenu *btnContinue = [CCMenu menuWithItems:btnContinueImage,nil];
        btnContinue.position = ccp(winSize.width/2.0,label.position.y - label.contentSize.height/2 - btnContinueImage.contentSize.height/2 - 50);
        [self addChild:btnContinue];
    }
    
#ifdef DEBUG
    [self performSelector:@selector(didTapContinue) withObject:nil afterDelay:4.0];
#endif
    return self;
}

-(void)didTapContinue {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TrainCatLayer sceneWithPracticeSetting:NO] withColor:ccWHITE]];
}


@end
