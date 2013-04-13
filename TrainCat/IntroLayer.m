//
//  IntroLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


// Import the interfaces
#import "IntroLayer.h"
#import "TrainCatLayer.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "TrainCatLayer.h"
#import "GameController.h"
#import "SpriteUtils.h"
#import "CCMenu+Extension.h"
#import "NSUserDefaults+Extensions.h"
#import "DSDropbox.h"
#import "SoundUtils.h"
#import "CCNode+Extension.h"
#import "BackgroundLayer.h"

#pragma mark - IntroLayer

@interface IntroLayer()

@end

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:getCocosBackgroundColor()]) ) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TrainCat.plist"];
    }
    return self;
}

-(void) viewWillAppear {
    [self setupUI];    
}

-(void)onEnterTransitionDidFinish {
    [self setupUI];
}


-(void)setupUI {
    [self removeAllChildrenWithCleanup:YES];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [self addChild:[BackgroundLayer node]];
    [self addChild:[[[[CCSprite spriteWithSpriteFrameName:@"clouds.png"] alignTop] alignCenter] shiftDown:20]];
    
    BOOL isLoggedIn =[[NSUserDefaults standardUserDefaults] loggedIn] ? YES : NO;
    BOOL isDropboxAuthenticated = [DSDropbox accountInfo] ? YES : NO;
    BOOL isPlayEnabled = isLoggedIn && isDropboxAuthenticated;
    
    NSArray *buttonPrefixs = @[(isPlayEnabled ? @"buttonPlay" : @"buttonPlayDisabled"),@"buttonPractice",@"buttonSettings"]; // MenuItems support a disabled image feature but we've done it this way (which is ok too)
    NSArray *buttonSelectors = @[(isPlayEnabled ? @"didTapPlay:" : @"didTapDisabledButton:"), @"didTapPractice:", @"didTapSettings:"];
    
    CCMenu *mnu = [CCMenu menuWithImagePrefixes:buttonPrefixs tags:nil target:self selectors:buttonSelectors];
    [mnu alignItemsVerticallyWithPadding:30];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mnu];

    if(!isPlayEnabled) {
        CCMenuItem *item = [mnu.children objectAtIndex:0];
        CCSprite *exclamation = [CCSprite spriteWithSpriteFrameName:@"largeAlertIcon.png"];
        exclamation.position = ccp(item.contentSize.width/2 + item.position.x + mnu.position.x - exclamation.contentSize.width/2 + 5, item.contentSize.height/2 + item.position.y + mnu.position.y - exclamation.contentSize.height/2 + 5);
        CCSprite *alert = [CCSprite spriteWithSpriteFrameName:@"dropboxAndLoginAlert.png"];
        alert.position = ccp(item.contentSize.width/2 + item.position.x + mnu.position.x + alert.contentSize.width/2, item.contentSize.height/2 + item.position.y + mnu.position.y - alert.contentSize.height/2);;        
            
        NSString *ns;
        if(!isDropboxAuthenticated && !isLoggedIn) {
            ns = @"Enable Dropbox and login a participant (tap Settings).";
        } else if(!isDropboxAuthenticated) {
            ns = @"Verify Dropbox credentials\n(tap Settings).";
        } else if(!isLoggedIn) {
            ns = @"Login a participant\n(tap Settings).";
        }
        
        float kNotificationPointerSize = 22.5;
        float kNotificationPadding = 20.0;
        CCSprite *notification = [CCLabelTTF
                                 labelWithString:ns
                                 dimensions:CGSizeMake(alert.contentSize.width-kNotificationPointerSize-kNotificationPadding,
                                                       alert.contentSize.height-kNotificationPadding)
                                            hAlignment:kCCTextAlignmentCenter
                                            vAlignment:kCCVerticalTextAlignmentCenter
                                            lineBreakMode:kCCLineBreakModeWordWrap
                                            fontName:kGameTextFont
                                            fontSize:15];
            
        notification.color = ccc3(255, 255, 255);
        notification.position = ccp(alert.position.x + kNotificationPointerSize/2, alert.position.y);
            
        [notification setScale:0.0];
        [exclamation setScale:0.0];
        [alert setScale:0.0];

        [self addChild:exclamation z:5];
        [self addChild:alert z:5];
        [self addChild:notification z:5];
                
        CCAction *popInAction = [CCSequence actions:[CCDelayTime actionWithDuration:0.5], [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]], nil];
        [exclamation runAction:popInAction];
        [alert runAction:[popInAction copy]];
        [notification runAction:[popInAction copy]];
    }
}

-(void)didTapPlay:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
#ifdef DDEBUG
    segueToScene([TrainCatLayer sceneWithSessionType:SessionTypeNormal]);
#else
    segueToScene([TrainCatLayer sceneWithSessionType:SessionTypeWarmup]);
#endif
    
}

-(void)didTapPractice:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
    segueToScene([TrainCatLayer sceneWithSessionType:SessionTypePractice]);
}

-(void)didTapSettings:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
    UIViewController *gc = getGameController();
    [gc performSegueWithIdentifier:@"segueToSettingsAuthentication" sender:gc];
}

@end
