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

#define RESPONSE_LAYER_BUTTON_PADDING 15

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCMenuItemImage *lbItem = [CCMenuItemImage itemWithNormalImage:@"buttonRespondLeftNormal.png" selectedImage:@"buttonRespondLeftSelected.png" target:self selector:@selector(didRespond:)];
        lbItem.tag = ResponseTypeLeft;
        CCMenu *lb = [CCMenu menuWithItems:lbItem,nil];
        lb.position = ccp(lbItem.contentSize.width/2 + RESPONSE_LAYER_BUTTON_PADDING, winSize.height/3.0);
        
        CCMenuItemImage *rbItem = [CCMenuItemImage itemWithNormalImage:@"buttonRespondRightNormal.png" selectedImage:@"buttonRespondRightSelected.png" target:self selector:@selector(didRespond:)];
        rbItem.tag = ResponseTypeRight;
        CCMenu *rb = [CCMenu menuWithItems:rbItem,nil];        
        rb.position = ccp(winSize.width-rbItem.contentSize.width/2-RESPONSE_LAYER_BUTTON_PADDING, winSize.height/3.0);
        
        //lb.visible = NO;
        //rb.visible = NO;
        /*
        id moveAction = [CCMoveTo ]
        id action = [CCEaseElasticOut actionWithAction:move period:0.3f]; */
        self.getResponseAction = [CCSequence actions:
                                  [CCDelayTime actionWithDuration:RESPONSE_DURATION],
                                  [CCCallFunc actionWithTarget:self selector:@selector(didSkipResponse)],
                                  nil];        
        
        [self addChild:lb];
        [self addChild:rb];
        
    }
    return self;
}

-(void)getResponse {    
    [self runAction:self.getResponseAction];
}

-(void)didSkipResponse {
    if(self.delegate) [self.delegate didRespond:ResponseTypeNoResponse];
}

-(void)didRespond:(CCMenuItem *)menuItem {
    [self stopAllActions];
    if(self.delegate) [self.delegate didRespond:menuItem.tag];
}

@end
