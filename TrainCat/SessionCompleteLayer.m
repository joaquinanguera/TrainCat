//
//  SessionCompleteLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "SessionCompleteLayer.h"
#import "TrainCatLayer.h"
#import "Participant+Extension.h"
#import "SpriteUtils.h"
#import "CCMenu+Extension.h"
#import "CCNode+Extension.h"
#import "ParticipantCompletionStatChartView.h"
#import "ParticipantPerformanceStatsChartView.h"
#import "BackgroundLayer.h"
#import "SimpleAudioEngine.h"
#import "Logger.h"

@interface SessionCompleteLayer()
@property (nonatomic, strong) Participant *participant;
@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, strong) ParticipantCompletionStatChartView *pieChart;
@property (nonatomic, strong) ParticipantPerformanceStatsChartView *lineChart;
@end

@implementation SessionCompleteLayer

+(CCScene *) sceneWithParticipant:(Participant *) participant sessionId:(NSInteger)sessionId gameOver:(BOOL)isGameOver
{
	CCScene *scene = [CCScene node];
	SessionCompleteLayer *gameLayer = [[SessionCompleteLayer alloc] initWithParticipant:participant sessionId:(NSInteger)sessionId gameOver:(BOOL)isGameOver];
	[scene addChild: gameLayer];
	return scene;
}

-(id)initWithParticipant:(Participant *)participant sessionId:(NSInteger)sessionId gameOver:(BOOL)isGameOver {
    if( (self=[super initWithColor:getCocosBackgroundColor()]) ) {
        [self addChild:[BackgroundLayer node]];
        self.participant = participant;
        self.sessionId = sessionId;
        self.isGameOver = isGameOver;

        CCSprite *header = [self makeHeaderWithTitle:isGameOver ? @"Game Over!" : @"Session Complete!"];
        header.opacity = 255*0.60;
        [self addChild:[[header alignTop] alignCenter]];
        CCLabelTTF *levelText = [CCLabelTTF
            labelWithString:@"Congratulations on getting this far!\nPress the home button on your iPad to exit the application."
            dimensions:CGSizeMake(getWinWidth(),100)
            hAlignment:kCCTextAlignmentCenter
            vAlignment:kCCVerticalTextAlignmentTop
            lineBreakMode:kCCLineBreakModeWordWrap
            fontName:kGameTextFont
            fontSize:32.f];
        
         levelText.color = ccc3(0, 0, 0);
         levelText.opacity = 0.0;
         [[[levelText alignMiddle] alignCenter] shiftDown:160];
         [self addChild:levelText];
         [levelText runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0] two:[CCFadeIn actionWithDuration:1.0]]];
        
        [Logger sendReportForParticipant:self.participant forSession:self.sessionId];
        if(self.isGameOver) {
            [Logger sendAllReportsForParticipant:self.participant];
        }
    }
    
    [self makeGraphs];
    return self;
}

-(void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    [UIView animateWithDuration:0.5 animations:^{
        self.pieChart.alpha = 1.0;
        self.lineChart.alpha = 1.0;
    }];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:kSessionCompleteBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:kSessionCompleteBackgroundMusic];
}


-(void)makeGraphs {
    self.pieChart = [[ParticipantCompletionStatChartView alloc] initWithFrame:CGRectMake(10, 80, 497, 352)];
    self.pieChart.backgroundColor = [UIColor clearColor];
    self.pieChart.alpha = 0;
    [self.pieChart chartWithCompletionStat:[self.participant completionStat]];
    [[[CCDirector sharedDirector] view] addSubview:self.pieChart];
    
    self.lineChart = [[ParticipantPerformanceStatsChartView alloc] initWithFrame:CGRectMake(517, 140, 497, 352)];
    self.lineChart.backgroundColor = [UIColor clearColor];
    self.lineChart.alpha = 0;
    [self.lineChart chartWithPoints:self.participant.performanceStats];
    [[[CCDirector sharedDirector] view] addSubview:self.lineChart];
}

-(CCSprite *)makeHeaderWithTitle:(NSString *)title {
    CCSprite *sprite = [SpriteUtils blankSpriteWithSize:CGSizeMake(getWinWidth(), 140)];
    sprite.color = ccBLACK;
    CCLabelTTF *line1 = [CCLabelTTF
                         labelWithString:title
                         dimensions:CGSizeMake(sprite.contentSize.width,65) // 65 to incorporate the g descent
                         hAlignment:kCCTextAlignmentCenter
                         vAlignment:kCCVerticalTextAlignmentTop
                         lineBreakMode:kCCLineBreakModeWordWrap
                         fontName:kGameTextFont
                         fontSize:55];
    
    [[[line1 alignTopTo:sprite] shiftDown:50] alignCenterTo:sprite];
    [sprite addChild:line1];
    
    return sprite;
}


-(void)onExitTransitionDidStart {
    [super onExitTransitionDidStart];
    [self.pieChart removeFromSuperview];
    [self.lineChart removeFromSuperview];
    [self stopAllActions];
}


@end
