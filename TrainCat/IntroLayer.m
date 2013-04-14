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
#import "CloudsLayer.h"

#pragma mark - IntroLayer

@interface IntroLayer()
@property (nonatomic, strong) CloudsLayer *cloudsLayer;
@end

// HelloWorldLayer implementation
@implementation IntroLayer

static const float kNotificationPointerSize = 22.5;
static const float kNotificationPadding = 20.0;

typedef NS_ENUM(NSInteger, IntroLayerSpriteTag) {
    kNotificationTag = 1,
    kAlertTag,
    kExclamationTag,
    kMenuTag
};

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:getCocosBackgroundColor()]) ) {        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TrainCat.plist"];
    }
    return self;
}

// Called the first time the scene is loaded
-(void)onEnterTransitionDidFinish {
    [self setupUI];
}

// Called when the scene becomes the current scene due to a popstack
-(void) viewWillAppear {
    [self updateUI];
}

-(void)viewWillDisappear {
    [self.cloudsLayer pauseAnimation];
}

-(void)setupUI {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.cloudsLayer = [CloudsLayer node];
    [self addChild:[BackgroundLayer node]];
    [self addChild:self.cloudsLayer];
    
    BOOL isLoggedIn =[[NSUserDefaults standardUserDefaults] loggedIn] ? YES : NO;
    BOOL isDropboxAuthenticated = [DSDropbox accountInfo] ? YES : NO;
    BOOL isPlayEnabled = isLoggedIn && isDropboxAuthenticated;
    
    NSArray *buttonPrefixs = @[@"buttonPlay",@"buttonPractice",@"buttonSettings"]; // MenuItems support a disabled image feature but we've done it this way (which is ok too)
    NSArray *buttonSelectors = @[@"didTapPlay:", @"didTapPractice:", @"didTapSettings:"];
    
    CCMenu *mnu = [CCMenu menuWithImagePrefixes:buttonPrefixs tags:nil target:self selectors:buttonSelectors];
    mnu.tag = kMenuTag;
    [mnu alignItemsVerticallyWithPadding:30];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mnu];
    
    if(!isPlayEnabled) {
        CCMenuItem *playButton = [mnu.children objectAtIndex:0];
        playButton.isEnabled = NO;
        
        CCSprite *exclamation = [CCSprite spriteWithSpriteFrameName:@"largeAlertIcon.png"];
        exclamation.tag = kExclamationTag;
        exclamation.position = ccp(playButton.contentSize.width/2 + playButton.position.x + mnu.position.x - exclamation.contentSize.width/2 + 5, playButton.contentSize.height/2 + playButton.position.y + mnu.position.y - exclamation.contentSize.height/2 + 5);

        CCSprite *alert = [CCSprite spriteWithSpriteFrameName:@"dropboxAndLoginAlert.png"];
        alert.tag = kAlertTag;
        alert.position = ccp(playButton.contentSize.width/2 + playButton.position.x + mnu.position.x + alert.contentSize.width/2, playButton.contentSize.height/2 + playButton.position.y + mnu.position.y - alert.contentSize.height/2);;        
            
        NSString *ns;
        if(!isDropboxAuthenticated && !isLoggedIn) {
            ns = @"Enable Dropbox and login a participant\n(tap Settings).";
        } else if(!isDropboxAuthenticated) {
            ns = @"Verify Dropbox credentials\n(tap Settings).";
        } else if(!isLoggedIn) {
            ns = @"Login a participant\n(tap Settings).";
        }
        
        CCLabelTTF *notification = [CCLabelTTF
                                 labelWithString:ns
                                 dimensions:CGSizeMake(alert.contentSize.width-kNotificationPointerSize-kNotificationPadding,
                                                       alert.contentSize.height-kNotificationPadding)
                                            hAlignment:kCCTextAlignmentCenter
                                            vAlignment:kCCVerticalTextAlignmentCenter
                                            lineBreakMode:kCCLineBreakModeWordWrap
                                            fontName:kGameTextFont
                                            fontSize:15];
        notification.tag = kNotificationTag;
        notification.color = ccc3(255, 255, 255);
        notification.position = ccp(alert.position.x + kNotificationPointerSize/2, alert.position.y);
        
        notification.scale = exclamation.scale = alert.scale = 0.0;

        [self addChild:exclamation z:5];
        [self addChild:alert z:5];
        [self addChild:notification z:5];
                
        CCAction *popInAction = [CCSequence actions:[CCDelayTime actionWithDuration:0.5], [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]], nil];
        [exclamation runAction:popInAction];
        [alert runAction:[popInAction copy]];
        [notification runAction:[popInAction copy]];
    }
}

-(void)updateUI {
    [self.cloudsLayer resumeAnimation];
    
    CCLabelTTF *notification = (CCLabelTTF *)[self getChildByTag:kNotificationTag];
    CCSprite *exclamation = (CCSprite *)[self getChildByTag:kExclamationTag];
    CCSprite *alert = (CCSprite *)[self getChildByTag:kAlertTag];
    notification.scale = exclamation.scale = alert.scale = 0.0;
    
    BOOL isLoggedIn =[[NSUserDefaults standardUserDefaults] loggedIn] ? YES : NO;
    BOOL isDropboxAuthenticated = [DSDropbox accountInfo] ? YES : NO;
    BOOL isPlayEnabled = isLoggedIn && isDropboxAuthenticated;
    
    CCMenu *mnu = (CCMenu *)[self getChildByTag:kMenuTag];
    CCMenuItem *playButton = [mnu.children objectAtIndex:0];
    playButton.isEnabled = isPlayEnabled;
    
    if(!isPlayEnabled) {
        NSString *ns;
        if(!isDropboxAuthenticated && !isLoggedIn) {
            ns = @"Enable Dropbox and login a participant (tap Settings).";
        } else if(!isDropboxAuthenticated) {
            ns = @"Verify Dropbox credentials (tap Settings).";
        } else if(!isLoggedIn) {
            ns = @"Login a participant\n(tap Settings).";
        }
        
        notification.string = ns;
        notification.position = ccp(alert.position.x + kNotificationPointerSize/2, alert.position.y);
        
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

-(void)onExit {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}


@end
