//
//  ResponseLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ResponseLayer.h"
#import "constants.h"


@interface ResponseLayer()

@property (nonatomic, strong) id getResponseAction;

@end

@implementation ResponseLayer

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CGFloat centerY = winSize.height/2;
        
        CCMenuItemImage *lbItem = [CCMenuItemImage itemWithNormalImage:@"ResponseLeft.png" selectedImage:@"ResponseLeft.png" target:self selector:@selector(didRespond:)];
        lbItem.tag = RESPONSE_LEFT;
        CCMenu *lb = [CCMenu menuWithItems:lbItem,nil];
        lb.position = ccp(lbItem.contentSize.width/2 + 100, centerY);
        
        CCMenuItemImage *rbItem = [CCMenuItemImage itemWithNormalImage:@"ResponseRight.png" selectedImage:@"ResponseRight.png" target:self selector:@selector(didRespond:)];
        rbItem.tag = RESPONSE_RIGHT;
        CCMenu *rb = [CCMenu menuWithItems:rbItem,nil];        
        rb.position = ccp(winSize.width-rbItem.contentSize.width/2-100, centerY);
        
        [self addChild:lb];
        [self addChild:rb];
        
        self.getResponseAction = [CCSequence actions:
         [CCDelayTime actionWithDuration:RESPONSE_DURATION],
         [CCCallFunc actionWithTarget:self selector:@selector(skippedResponse)],
         nil];
        
    }
    return self;
}

-(void)getResponse {
    [self runAction:self.getResponseAction];
}

-(void)skippedResponse {
    if(self.delegate) [self.delegate didRespond:RESPONSE_SKIPPED];
}

-(void)didRespond:(CCMenuItem *)menuItem {
    [self stopAllActions];
    if(self.delegate) [self.delegate didRespond:menuItem.tag];
}

@end
