//
//  ResponseLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "ResponseLayer.h"
#import "constants.h"
#import "SoundUtils.h"


@interface ResponseLayer()

@property (nonatomic, strong) id getResponseAction;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) BOOL hasResponded;

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
    self.hasResponded = NO;
    self.startTime = [NSDate date];
    [self runAction:self.getResponseAction];
}

-(void)didSkipResponse {
    if(!self.hasResponded) {
        [self stopAllActions];
        self.hasResponded = YES;
        if(self.delegate) [self.delegate didRespond:ResponseTypeNoResponse responseTime:-[self.startTime timeIntervalSinceNow]];
    }
}

-(void)didRespond:(CCMenuItem *)menuItem {
    if(!self.hasResponded) {
        self.hasResponded = YES;
        [self stopAllActions];
        NSTimeInterval rt = -[self.startTime timeIntervalSinceNow];
        if(self.delegate) [self.delegate didRespond:menuItem.tag responseTime:rt];
        [SoundUtils playInputClick];
    }
}

-(void)clear {
    self.hasResponded = NO;
}

@end
