//
//  DropboxLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "DropboxLayer.h"
#import "DSDropbox.h"
#import "Toast+UIView.h"
#import "constants.h"
#import "IntroLayer.h"
#import "Toast+UIView.h"
#import "SpriteUtils.h"
#import "CCMenu+Extensions.h"

@interface DropboxLayer()

@property (nonatomic, strong) CCLabelTTF *label;
@property (nonatomic, strong) CCMenu *retryButton;

@end

@implementation DropboxLayer
// Helper class method that creates a Scene with the DropboxLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DropboxLayer *gameLayer = [DropboxLayer node];
    
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:BACKGROUND_COLOR]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        self.label = [CCLabelTTF labelWithString:@"Could not authenticate DropBox. Try again." fontName:@"DevanagariSangamMN-Bold" fontSize:30];
        self.label.position = ccp(winSize.width/2, winSize.height/2 + self.label.contentSize.height/2 + STIMULUS_PADDING/2);
        self.label.visible = NO;
        
        self.retryButton = [CCMenu menuWithImagePrefix:@"buttonRetry" tag:0 target:self selector:@selector(didTapRetry)];
        self.retryButton.position = ccp(winSize.width/2, winSize.height/2 - ((CCMenuItem *)[self.retryButton.children lastObject]).contentSize.height/2 - STIMULUS_PADDING/2);
        self.retryButton.visible = NO;

        [self addChild:background];
        [self addChild:self.label];
        [self addChild:self.retryButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteDropboxLinkAttempt:) name:DS_DROPBOX_LINK_ATTEMPT_COMPLETE object:nil];
    return self;
}

-(void)onEnterTransitionDidFinish {
    [self authenticateDropbox];
}

- (void)authenticateDropbox {
    [DSDropbox linkWithDelegate:(UIViewController *)([CCDirector sharedDirector].delegate)];
}

-(void)didCompleteDropboxLinkAttempt:(NSNotification *)notification {
    NSObject *obj = [notification object];
    if(!obj) {
        self.label.visible = YES;
        self.retryButton.visible = YES;
        [self.label runAction:[CCBlink actionWithDuration:1.0 blinks:3]];
        [self.retryButton runAction:[CCBlink actionWithDuration:1.0 blinks:3]];
    } else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[IntroLayer node]]];
    }
}

-(void)didTapRetry {
    self.label.visible = NO;
    self.retryButton.visible = NO;
    [self authenticateDropbox];
}

@end
