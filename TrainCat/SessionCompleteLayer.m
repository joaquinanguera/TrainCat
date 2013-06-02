//
//  SessionCompleteLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Dropbox/Dropbox.h>
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
@property (nonatomic, strong) CCLabelTTF *txtUploading;
@property (nonatomic, strong) CCLabelTTF *txtDone;
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
        
        // Setup uploading label
        self.txtUploading = [CCLabelTTF
            labelWithString:@"Please wait while we report your progress to our system...\nDO NOT EXIT THE APPLICATION!"
            dimensions:CGSizeMake(getWinWidth(),100)
            hAlignment:kCCTextAlignmentCenter
            vAlignment:kCCVerticalTextAlignmentTop
            lineBreakMode:kCCLineBreakModeWordWrap
            fontName:kGameTextFont
            fontSize:22.f];
         self.txtUploading.color = ccc3(0, 0, 0);
         self.txtUploading.opacity = 0.0;
         [[[self.txtUploading alignMiddle] alignCenter] shiftDown:170];
         [self addChild:self.txtUploading];
         [self.txtUploading runAction:[CCFadeIn actionWithDuration:0.5]];
        
        // Setup done label
        self.txtDone = [CCLabelTTF
                             labelWithString:@"All done! Congratulations on getting this far!\nYou may now exit the application by tapping the home button on your iPad."
                             dimensions:CGSizeMake(getWinWidth(),100)
                             hAlignment:kCCTextAlignmentCenter
                             vAlignment:kCCVerticalTextAlignmentTop
                             lineBreakMode:kCCLineBreakModeWordWrap
                             fontName:kGameTextFont
                             fontSize:22.f];
        self.txtDone.color = ccc3(0, 0, 0);
        self.txtDone.opacity = 0.0;
        [[[self.txtDone alignMiddle] alignCenter] shiftDown:170];
        [self addChild:self.txtDone];

        [Logger sendReportForParticipant:self.participant forSession:self.sessionId];
        [self performSelector:@selector(updateSynchStatus) withObject:self afterDelay:0.5];
        
        if(self.isGameOver) {
            [Logger sendAllReportsForParticipant:self.participant];
        }
    }
    
    [self makeGraphs];
    return self;
}

-(void)updateSynchStatus {
    if([[DBFilesystem sharedFilesystem] status] & DBSyncStatusUploading) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [getGameController().activityIndicator startAnimating];
        [self performSelector:@selector(updateSynchStatus) withObject:self afterDelay:1];
    } else {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [getGameController().activityIndicator stopAnimating];
        [self.txtUploading runAction:[CCFadeOut actionWithDuration:0.5]];
        [self.txtDone runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.5] two:[CCFadeIn actionWithDuration:0.5]]];
    }
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
    [[[CCDirector sharedDirector] view] insertSubview:self.pieChart belowSubview:[getGameController() activityIndicator]];
    
    self.lineChart = [[ParticipantPerformanceStatsChartView alloc] initWithFrame:CGRectMake(517, 140, 497, 352)];
    self.lineChart.backgroundColor = [UIColor clearColor];
    self.lineChart.alpha = 0;
    [self.lineChart chartWithPoints:self.participant.performanceStats];
    [[[CCDirector sharedDirector] view] insertSubview:self.lineChart belowSubview:[getGameController() activityIndicator]];
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
