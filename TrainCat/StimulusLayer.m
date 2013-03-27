//
//  StimlusLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StimulusLayer.h"
#import "StimulusPack.h"
#import "StimulusCategory.h"
#import "StimulusList.h"
#import "SpriteUtils.h"
#import "constants.h"


@interface StimulusLayer()
@property (nonatomic, strong) CCSprite *fixation;
@property (nonatomic, copy) NSString *exemplarLeftPath; // Determines if cache is invalid
@end

@implementation StimulusLayer

-(void)showStimulusWithExemplarLeftPath:(NSString *)exemplarLeftPath exemplarRightPath:(NSString *)exemplarRightPath morphPath:(NSString *)morphPath {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat centerX = winSize.width/2;
    CGFloat centerY = winSize.height/2;
    
    CCNode *exemplar;
    if(exemplarLeftPath && ![exemplarLeftPath isEqualToString:self.exemplarLeftPath]) {
        [self removeChildByTag:EXEMPLAR_TAG cleanup:YES]; // Remove exemplar and all it's children.
        // Exemplar
        exemplar = [CCNode node];
        exemplar.visible = NO;
        
        CCSprite *el = [CCSprite spriteWithFile:exemplarLeftPath];
        el.position = ccp(centerX - el.contentSize.width/2 - STIMULUS_PADDING, centerY);
        [exemplar addChild:el];
        
        CCSprite *elBar = [SpriteUtils blankSpriteWithSize:CGSizeMake(el.contentSize.width, 25.0f)];
        elBar.color = ccc3(178, 127, 178);
        elBar.position = ccp(centerX - elBar.contentSize.width/2 -  STIMULUS_PADDING, centerY - elBar.contentSize.height/2 - el.contentSize.height/2);
        [exemplar addChild:elBar];
        
        CCSprite *er = [CCSprite spriteWithFile:exemplarRightPath];
        er.position = ccp(centerX + er.contentSize.width/2 + STIMULUS_PADDING, centerY);
        [exemplar addChild:er];
        
        CCSprite *erBar = [SpriteUtils blankSpriteWithSize:CGSizeMake(er.contentSize.width, 25.0f)];
        erBar.color = ccc3(127, 191, 127);
        erBar.position = ccp(centerX + erBar.contentSize.width/2 + STIMULUS_PADDING, centerY - erBar.contentSize.height/2 - er.contentSize.height/2);
        [exemplar addChild:erBar];
        
        [self addChild:exemplar z:0 tag:EXEMPLAR_TAG];
    } else {
        exemplar = [self getChildByTag:EXEMPLAR_TAG];
    }
    
    
    // Morph
    CCSprite *morph = [CCSprite spriteWithFile:morphPath];
    morph.position = ccp(centerX, centerY);
    morph.visible = NO;
    [self addChild:morph z:0 tag:MORPH_TAG];
    
    id actionShowFixation = [CCSequence actions:
                             [CCShow action],
                             [CCDelayTime actionWithDuration:FIXATION_DURATION_MAX],
                             [CCHide action],
                             nil];
    CCTargetedAction *actionFixation = [CCTargetedAction actionWithTarget:self.fixation action:actionShowFixation];
    
    
    id actionShowExemplar = [CCSequence actions:
                             [CCShow action],
                             [CCDelayTime actionWithDuration:EXEMPLAR_DURATION],
                             [CCHide action],
                             nil];
    CCTargetedAction *actionExemplar = [CCTargetedAction actionWithTarget:exemplar action:actionShowExemplar];
    
    
    id actionShowMorph = [CCSequence actions:
                          [CCDelayTime actionWithDuration:MASK_DURATION],
                          [CCShow action],
                          [CCDelayTime actionWithDuration:MORPH_DURATION],
                          [CCHide action],
                          [CCDelayTime actionWithDuration:MASK_DURATION],
                          [CCCallFunc actionWithTarget:self selector:@selector(finished)],
                          nil];
    CCTargetedAction *actionMorph = [CCTargetedAction actionWithTarget:morph action:actionShowMorph];
    
    CCSequence *stimAction = [CCSequence actions:actionFixation, actionExemplar, actionMorph, nil];
    [self runAction:stimAction];
}

-(void)finished {    
    [self removeChildByTag:MORPH_TAG cleanup:YES]; // Remove morph.
    // Do not remove fixation
    if(self.delegate) [self.delegate stimulusDidFinish];
}

-(CCSprite *)fixation {
    if(!_fixation) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _fixation = [CCSprite spriteWithFile:@"fixation.png"];
        _fixation.position = ccp(winSize.width/2, winSize.height/2);
        _fixation.visible = NO;
        [self addChild:_fixation];
    }
    return _fixation;
}


@end
