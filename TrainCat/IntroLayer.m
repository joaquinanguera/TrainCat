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
#import "Participant+Extension.h"
#import "SpriteUtils.h"
#import "CCMenu+Extensions.h"
#import "NSUserDefaults+Extensions.h"
#import "DSDropbox.h"
#import "SoundUtils.h"

#pragma mark - IntroLayer

@interface IntroLayer()

@property (nonatomic, strong) CCMenu *menu;
@property (nonatomic, strong) CCSprite *exclamation;
@property (nonatomic, strong) CCSprite *alert;
@property (nonatomic, strong) CCLabelTTF *notification;
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
    if( (self=[super initWithColor:BACKGROUND_COLOR]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background];
    }
    return self;
}

-(void) onEnter
{
	[super onEnter];
    [self makeMenu];
}

-(void) viewWillAppear {
    [self initNotification];    
    [self makePrimaryMenu];
}

-(void)makeMenu {
    [self makePrimaryMenu];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMenu *mnuToggleSound = [CCMenu menuWithImagePrefix:@"iconSpeaker" tag:0 target:self selector:@selector(didTapToggleBackgroundMusic:)];
    mnuToggleSound.position = ccp(winSize.width - mnuToggleSound.button.contentSize.width/2 - STIMULUS_PADDING, mnuToggleSound.button.contentSize.height/2 + STIMULUS_PADDING);
    
    [self addChild:mnuToggleSound];
}

-(void)didTapPlay:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
#ifdef DDEBUG
    //[Participant clearStateForParticipantWithId:[SessionManager loggedIn]];
    
#endif
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPracticeSetting:NO]]];    
}

-(void)didTapPractice:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[TrainCatLayer sceneWithPractice:YES]]];    
}

-(void)didTapSettings:(CCMenuItem *)menuItem {
    [SoundUtils playInputClick];
    GameController *gc = (GameController *)([CCDirector sharedDirector].delegate);
    [gc performSegueWithIdentifier:@"segueToSettingsAuthentication" sender:gc];
}


-(void)didTapToggleBackgroundMusic:(CCMenuItem *)menuItem {
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        ((CCMenuItemImage *)menuItem).opacity = 128;
    } else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme.mp3"]; // Currently throwing an error
        ((CCMenuItemImage *)menuItem).opacity = 255;
    }
}

-(void)makePrimaryMenu {
    if(self.menu) {
        [self removeChild:self.menu cleanup:YES];
    }
    
    BOOL isLoggedIn =[[NSUserDefaults standardUserDefaults] loggedIn];
    BOOL isDropboxAuthenticated = [DSDropbox accountInfo];
    BOOL isPlayEnabled = isLoggedIn && isDropboxAuthenticated;
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSArray *buttonPrefixs = [[NSArray alloc] initWithObjects:
                              (isPlayEnabled ? @"buttonPlay" : @"buttonPlayDisabled"),
                              @"buttonPractice",
                              @"buttonSettings",
                              nil];
    NSArray *buttonSelectors = [[NSArray alloc] initWithObjects:@"didTapPlay:", @"didTapPractice:", @"didTapSettings:", nil];
    
    CCMenu *mnu = [CCMenu menuWithImagePrefixes:buttonPrefixs tags:nil target:self selectors:buttonSelectors];
    [mnu alignItemsVerticallyWithPadding:30];
    mnu.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mnu];
    self.menu = mnu;

    if(!isPlayEnabled) {
        CCMenuItem *item = [mnu.children objectAtIndex:0];
        if(!self.exclamation) {
            self.exclamation = [CCSprite spriteWithFile:@"largeAlertIcon.png"];
            self.exclamation.position = ccp(item.contentSize.width/2 + item.position.x + mnu.position.x - self.exclamation.contentSize.width/2 + 5, item.contentSize.height/2 + item.position.y + mnu.position.y - self.exclamation.contentSize.height/2 + 5);
            
            self.alert = [CCSprite spriteWithFile:@"dropboxAndLoginAlert.png"];
            self.alert.position = ccp(item.contentSize.width/2 + item.position.x + mnu.position.x + self.alert.contentSize.width/2, item.contentSize.height/2 + item.position.y + mnu.position.y - self.alert.contentSize.height/2);;        
            
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
            if(self.notification) {
                [self removeChild:self.notification cleanup:YES];
            }
            self.notification = [CCLabelTTF
                                 labelWithString:ns
                                 dimensions:CGSizeMake(self.alert.contentSize.width-kNotificationPointerSize-kNotificationPadding,
                                                       self.alert.contentSize.height-kNotificationPadding)
                                            hAlignment:kCCTextAlignmentCenter
                                            vAlignment:kCCVerticalTextAlignmentCenter
                                            lineBreakMode:kCCLineBreakModeWordWrap
                                            fontName:GAME_TEXT_FONT
                                            fontSize:15];
            
            self.notification.color = ccc3(255, 255, 255);
            self.notification.position = ccp(self.alert.position.x + kNotificationPointerSize/2, self.alert.position.y);
            
            [self initNotification];
            [self addChild:self.exclamation z:5];
            [self addChild:self.alert z:5];
            [self addChild:self.notification z:5];
        }
        
        CCAction *popInAction = [CCSequence actions:[CCDelayTime actionWithDuration:0.5], [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]], nil];
        [self.exclamation runAction:popInAction];
        [self.alert runAction:[popInAction copy]];
        [self.notification runAction:[popInAction copy]];
    }
}

-(void)initNotification {
    [self.notification setScale:0.0];
    [self.exclamation setScale:0.0];
    [self.alert setScale:0.0];
}


-(void)onExit {
    //[self didTapToggleBackgroundMusic];
    [super onExit];
}

@end
