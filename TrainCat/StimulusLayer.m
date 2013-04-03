//
//  StimlusLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "StimulusLayer.h"
#import "StimulusPack.h"
#import "StimulusCategory.h"
#import "StimulusList.h"
#import "SpriteUtils.h"
#import "constants.h"
#import "SimpleAudioEngine.h"

@interface StimulusLayer()
@property (nonatomic, copy) NSString *exemplarLeftPath; // Determines if cache is invalid
@end

@implementation StimulusLayer

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *fixation = [CCSprite spriteWithFile:@"fixation.png"];
        fixation.tag = StimulusTypeFixation;
        fixation.position = ccp(winSize.width/2, winSize.height/2);
        fixation.opacity = 0;
        [self addChild:fixation z:StimulusZIndexFixation];
        
        CCSprite *exemplarMask = [SpriteUtils blankSpriteWithSize:winSize];
        exemplarMask.tag = StimulusTypeMask;
        exemplarMask.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:exemplarMask z:StimulusZIndexMask];
        
    }
    return self;
}

-(void)showStimulusWithExemplarLeftPath:(NSString *)exemplarLeftPath exemplarRightPath:(NSString *)exemplarRightPath morphLabel:(NSString *)morphLabel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGFloat centerX = winSize.width/2;
    CGFloat centerY = winSize.height/2;
    
    CCNode *exemplar;
    
    if(exemplarLeftPath && ![exemplarLeftPath isEqualToString:self.exemplarLeftPath]) {
        [self removeChildByTag:StimulusTypeExemplar cleanup:YES];
                
        // Create
        exemplar = [SpriteUtils blankSpriteWithSize:winSize];
        exemplar.position = ccp(centerX, centerY);
        exemplar.tag = StimulusTypeExemplar;

        CCSprite *el = [CCSprite spriteWithFile:exemplarLeftPath];
        CCSprite *er = [CCSprite spriteWithFile:exemplarRightPath];
        
        CGFloat maxHeight = max(el.contentSize.height, er.contentSize.height);
        CGFloat maxWidth = max(el.contentSize.width, er.contentSize.width);
        
        CCSprite *elBar = [SpriteUtils blankSpriteWithSize:CGSizeMake(maxWidth, 25.0)];
        elBar.color = ccc3(178, 127, 178);
        CCSprite *erBar = [SpriteUtils blankSpriteWithSize:CGSizeMake(maxWidth, 25.0)];
        erBar.color = ccc3(127, 191, 127);
        
        
        // Position
        el.position = ccp(winSize.width/4.0, centerY - (maxHeight - el.contentSize.height)/2.0);
        elBar.position = ccp(winSize.width/4.0, el.position.y - el.contentSize.height/2 - elBar.contentSize.height/2.0 - STIMULUS_BAR_PADDING_TOP);
        er.position = ccp(winSize.width*3.0/4.0, centerY - (maxHeight - er.contentSize.height)/2.0);
        erBar.position = ccp(winSize.width*3.0/4.0, er.position.y - er.contentSize.height/2 - erBar.contentSize.height/2.0 - STIMULUS_BAR_PADDING_TOP);
        
        // Add
        [exemplar addChild:el];
        [exemplar addChild:elBar];
        [exemplar addChild:er];
        [exemplar addChild:erBar];
        
        [self addChild:exemplar z:StimulusZIndexExemplar];
    } else {
        exemplar = [self getChildByTag:StimulusTypeExemplar];
    }
    
    
    // Morph
    CCSprite *morph = [CCSprite spriteWithFile:morphLabel];
    morph.tag = StimulusTypeMorph;
    morph.position = ccp(centerX, centerY);
    morph.opacity = 0;
    [self addChild:morph z:StimulusZIndexMorph];
    
    id actionShowFixation = [CCSequence actions:
                             [CCFadeIn actionWithDuration:FADE_DURATION],
                             [CCDelayTime actionWithDuration:FIXATION_DURATION_MAX],
                             [CCFadeOut actionWithDuration:FADE_DURATION],
                             nil];
    CCTargetedAction *actionFixation = [CCTargetedAction actionWithTarget:[self getChildByTag:StimulusTypeFixation] action:actionShowFixation];
    
    
    id actionShowExemplar = [CCSequence actions:
                             [CCFadeOut actionWithDuration:FADE_DURATION],
                             [CCDelayTime actionWithDuration:EXEMPLAR_DURATION],
                             [CCFadeIn actionWithDuration:FADE_DURATION],
                             nil];
    CCTargetedAction *actionExemplar = [CCTargetedAction actionWithTarget:[self getChildByTag:StimulusTypeMask] action:actionShowExemplar];
    
    id actionShowMorph = [CCSequence actions:
                          [CCDelayTime actionWithDuration:MASK_DURATION],
                          [CCFadeIn actionWithDuration:FADE_DURATION],
                          [CCDelayTime actionWithDuration:MORPH_DURATION],
                          [CCFadeOut actionWithDuration:FADE_DURATION],
                          [CCDelayTime actionWithDuration:MASK_DURATION],
                          [CCCallFunc actionWithTarget:self selector:@selector(finished)],
                          nil];
    CCTargetedAction *actionMorph = [CCTargetedAction actionWithTarget:[self getChildByTag:StimulusTypeMorph] action:actionShowMorph];
    
    CCSequence *stimAction = [CCSequence actions:actionFixation, actionExemplar, actionMorph, nil];
    [self runAction:stimAction];
}

-(void)clear {
    // Do nothing
}

-(void)finished {    
    [self removeChildByTag:StimulusTypeMorph cleanup:YES]; // Remove morph.
    // Do not remove fixation
    if(self.delegate) [self.delegate stimulusDidFinish];
}


@end
