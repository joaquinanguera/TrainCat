//
//  ResponseLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "ResponseLayer.h"
#import "CocosConstants.h"
#import "SoundUtils.h"
#import "CCMenu+Extension.h"
#import "CCNode+Extension.h"

@interface ResponseLayer()

@property (nonatomic, strong) id getResponseAction;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) BOOL hasResponded;

@end

@implementation ResponseLayer

static const NSUInteger kResponseLayerHorizontalPadding = 15;

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCMenu *lb = [CCMenu menuWithImagePrefix:@"buttonRespondLeft" tag:ResponseTypeLeft target:self selector:@selector(didRespond:)];
        double responseLayerVerticalPadding = winSize.height/3.0 - getMenuButton(lb).contentSize.height/2.0; // The center should be placed at 33%
        
        [[[[lb alignLeft] alignBottom] shiftUp:responseLayerVerticalPadding] shiftRight:kResponseLayerHorizontalPadding];
        //lb.position = ccp(getMenuButton(lb).contentSize.width/2 + RESPONSE_LAYER_BUTTON_PADDING, winSize.height/3.0);
        
        CCMenu *rb = [CCMenu menuWithImagePrefix:@"buttonRespondRight" tag:ResponseTypeRight target:self selector:@selector(didRespond:)];
        //rb.position = ccp(winSize.width-rbItem.contentSize.width/2-RESPONSE_LAYER_BUTTON_PADDING, winSize.height/3.0);
        [[[[rb alignRight] alignBottom] shiftUp:responseLayerVerticalPadding] shiftLeft:kResponseLayerHorizontalPadding];
        
        self.getResponseAction = [CCSequence actions:
                                  [CCDelayTime actionWithDuration:kResponseDuration],
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
