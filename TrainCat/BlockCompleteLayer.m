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
#import "SpriteUtils.h"
#import "IntroLayer.h"
#import "CCMenu+Extension.h"
#import "CCNode+Extension.h"

@interface BlockCompleteLayer()
@property (nonatomic, strong) Participant *participant;
@property (nonatomic, assign) SessionType sessionType;
@property (nonatomic, strong) id levelMeterAnimation;
@property (nonatomic, strong) CCLabelTTF *levelText;
@property (nonatomic, assign) ALuint backgroundScoreId;
@end

#define kBlockCompleteEffect @"blockComplete.mp3"
#define kFeedbackSoundCorrect @"correct2.mp3"
#define kSpriteRewardPostive @"iconRewardPositive.png"
#define kSpriteRewardNegative @"iconRewardNegative.png"

#define kBlockCompleteMeterPositionPadding 50
#define kBlockCompleteMeterElementPadding 15.0f

@implementation BlockCompleteLayer

+(CCScene *) sceneWithParticipant:(Participant *) participant sessionType:(SessionType)sessionType;
{
	CCScene *scene = [CCScene node];
	BlockCompleteLayer *gameLayer = [[BlockCompleteLayer alloc] initWithParticipant:participant sessionType:sessionType];
	[scene addChild: gameLayer];
	return scene;
}

-(id)initWithParticipant:(Participant *)participant sessionType:(SessionType)sessionType {
    if( (self=[super initWithColor:BACKGROUND_COLOR]) ) {
        self.participant = participant;
        self.sessionType = sessionType;
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:kBlockCompleteEffect];
        [self addChild:[BackgroundLayer node]];
        
        CCSprite *header = [self makeHeader];
        [[header alignCenter] alignTop];
        header.opacity = 255*0.60;
        [self addChild:header];
        
        NSUInteger level = [self.participant levelForLastBlock];
        self.levelText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You reached level %d.", level] fontName:GAME_TEXT_FONT fontSize:32.f];
        self.levelText.color = ccc3(0, 0, 0);
        self.levelText.opacity = 0.0;
        [self addChild:self.levelText];
        
        CCSprite *levelMeter = [self setupLevelMeterWithLevel:level maxLevels:MAX_STIMULUS_LEVEL rows:2];
        // levelMeter adds itself to the stage cause otherwise the actions construction code seems to barf.
        // Not the most elegant solution but it will do for now. 
        [[[levelMeter alignCenter] alignMiddle] shiftUp:kBlockCompleteMeterPositionPadding];
        [[[self.levelText alignCenter] alignMiddle] shiftDown:(levelMeter.contentSize.height/2)];
        
        switch(self.sessionType) {
            case SessionTypeWarmup: {
                CCMenu *btnBack = [CCMenu menuWithImagePrefix:@"buttonBack" tag:0 target:self selector:@selector(didTapBackToWarmup)];
                [[[[btnBack alignBottom] alignLeft] shiftRight:25.0] shiftUp:25.0];
                [self addChild:btnBack];
            }
                // fall through
            case SessionTypeNormal: {
                CCMenu *btnContinue = [CCMenu menuWithImagePrefix:@"buttonContinue" tag:0 target:self selector:@selector(didTapContinueToNextBlock)];
                [[[[btnContinue alignBottom] alignRight] shiftLeft:25.0] shiftUp:25.0];
                [self addChild:btnContinue];
            }
                break;
            case SessionTypePractice: {
                CCMenu *btnContinue = [CCMenu menuWithImagePrefix:@"buttonContinue" tag:0 target:self selector:@selector(didTapContinueToMainMenu)];
                [[[[btnContinue alignBottom] alignRight] shiftLeft:25.0] shiftUp:25.0];
                [self addChild:btnContinue];
                
                CCMenu *btnBack = [CCMenu menuWithImagePrefix:@"buttonBack" tag:0 target:self selector:@selector(didTapBackToPractice)];
                [[[[btnBack alignBottom] alignLeft] shiftRight:25.0] shiftUp:25.0];
                [self addChild:btnBack];
            }
                break;
        }
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:kFeedbackSoundCorrect];        
    }
    
    return self;
}

-(CCSprite *)makeHeader {
    CCSprite *sprite = [SpriteUtils blankSpriteWithSize:CGSizeMake(WIN_WIDTH, 140)];
    sprite.color = ccBLACK;
    
    CCLabelTTF *line1 = [CCLabelTTF
                     labelWithString:@"Congratulations!"
                     dimensions:CGSizeMake(sprite.contentSize.width,65) // 65 to incorporate the g descent
                     hAlignment:kCCTextAlignmentCenter
                     vAlignment:kCCVerticalTextAlignmentTop
                     lineBreakMode:kCCLineBreakModeWordWrap
                     fontName:GAME_TEXT_FONT
                     fontSize:55];
    
    NSString *line2Text;    
    switch(self.sessionType) {
        case SessionTypeNormal:
            line2Text = @"You finished a block.";
            break;
        case SessionTypePractice:
            line2Text = @"You finished the practice session.";
            break;
        case SessionTypeWarmup:
            line2Text = @"You finished the warmup session.";
            break;
    }
    CCLabelTTF *line2 = [CCLabelTTF
                         labelWithString:line2Text
                         dimensions:CGSizeMake(sprite.contentSize.width,35)
                         hAlignment:kCCTextAlignmentCenter
                         vAlignment:kCCVerticalTextAlignmentTop
                         lineBreakMode:kCCLineBreakModeWordWrap
                         fontName:GAME_TEXT_FONT
                         fontSize:30];
    
    NSString *line3Text;
    switch (self.sessionType) {
        case SessionTypeNormal:
            line3Text = [NSString stringWithFormat:@"Only %d more to go for today!", MAX_STIMULUS_BLOCKS - [self.participant blocksCompletedInCurrentSession]];
            break;
        case SessionTypePractice:
            line3Text = @"Tap Back to practice again. Tap Continue to the Game Menu.";
            break;
        case SessionTypeWarmup:
            line3Text = @"Tap Back to warmup some more. Tap Continue to begin today's session.";
            break;
    }
    
    CCLabelTTF *line3 = [CCLabelTTF
                         labelWithString:line3Text
                         dimensions:CGSizeMake(sprite.contentSize.width,28)
                         hAlignment:kCCTextAlignmentCenter
                         vAlignment:kCCVerticalTextAlignmentTop
                         lineBreakMode:kCCLineBreakModeWordWrap
                         fontName:GAME_TEXT_FONT
                         fontSize:18];
    
    [[line1 alignCenterTo:sprite] alignTopTo:sprite];
    [[[line2 alignCenterTo:sprite] alignTopTo:sprite] shiftDown:65];
    [[[line3 alignCenterTo:sprite] alignTopTo:sprite] shiftDown:(65+35)];
    [sprite addChild:line1];
    [sprite addChild:line2];
    [sprite addChild:line3];
    return sprite;
}

-(CCSprite *)setupLevelMeterWithLevel:(NSUInteger)level maxLevels:(NSUInteger)maxLevels rows:(NSUInteger)rows {
    // TODO: This should be in a sprite sheet
    CCSprite *sprite = [CCSprite spriteWithFile:@"iconRewardPositive.png"];
    
    float iconWidth = sprite.contentSize.width;
    float iconHeight = sprite.contentSize.height;
    float padding = kBlockCompleteMeterElementPadding;

    NSUInteger itemsPerRow = ((maxLevels%2)? maxLevels : (maxLevels+1)) / rows;
    
    float containerWidth = iconWidth*itemsPerRow+padding*(itemsPerRow-1);
    float containerHeight = iconHeight*rows+padding*(rows-1);
    
    CCSprite *result = [SpriteUtils blankSpriteWithSize:CGSizeMake(containerWidth, containerHeight)];
    result.opacity = 0;
    [self addChild:result];
    
    float x = sprite.contentSize.width/2, y = containerHeight - sprite.contentSize.height/2;
    
    
    NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:level];
    
    for(NSUInteger i=0; i<maxLevels; ++i) {
        sprite = [CCSprite spriteWithFile:@"iconRewardNegative.png"];
        sprite.position = ccp(x,y);
        [result addChild:sprite];
        
        if(i < level) {
            CCSprite *psprite = [CCSprite spriteWithFile:@"iconRewardPositive.png"];
            psprite.opacity = 0;
            psprite.position = sprite.position;
            [result addChild:psprite];
            
            [actions addObject:[CCDelayTime actionWithDuration:0.5]];
            [actions addObject:[CCTargetedAction actionWithTarget:psprite action:[CCFadeIn actionWithDuration:0.25]]];
            [actions addObject:[CCCallFunc actionWithTarget:self selector:@selector(playLevelUpSound)]];
        }
        
        x += sprite.contentSize.width + padding;
        if(x >= containerWidth) {
            x = sprite.contentSize.width/2;
            y -= iconHeight + padding;
        }
    }
    
    [actions addObject:[CCDelayTime actionWithDuration:0.5]];
    [actions addObject:[CCTargetedAction actionWithTarget:self.levelText action:[CCFadeIn actionWithDuration:0.25]]];
    [actions addObject:[CCDelayTime actionWithDuration:0.5]];
    [actions addObject:[CCCallFunc actionWithTarget:self selector:@selector(playBackgroundScore)]];
    
    
    self.levelMeterAnimation = [CCSequence actionWithArray:actions];
    return result;
}

-(void)playLevelUpSound {
    [[SimpleAudioEngine sharedEngine] playEffect:kFeedbackSoundCorrect];
}

-(void)playBackgroundScore {
    self.backgroundScoreId = [[SimpleAudioEngine sharedEngine] playEffect:kBlockCompleteEffect];
}

-(void)onEnter {
    [super onEnter];
    [self runAction:self.levelMeterAnimation];
#ifdef DDEBUG
    [self performSelector:@selector(didTapContinueToNextBlock) withObject:self afterDelay:1.5];
#endif
}

-(void)didTapContinueToNextBlock {
    SEGUE_TO_SCENE([TrainCatLayer sceneWithSessionType:SessionTypeNormal]);
}

-(void)didTapBackToWarmup {
    SEGUE_TO_SCENE([TrainCatLayer sceneWithSessionType:SessionTypeWarmup]);
}

-(void)didTapContinueToMainMenu {
    SEGUE_TO_SCENE([IntroLayer scene]);
}

-(void)didTapBackToPractice {
    SEGUE_TO_SCENE([TrainCatLayer sceneWithSessionType:SessionTypePractice]);
}

-(void)onExit {
    [super onExit];
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:self.backgroundScoreId];
}


@end
