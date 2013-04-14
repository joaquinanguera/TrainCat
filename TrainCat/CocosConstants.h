//
//  CocosConstants.h
//  TrainCat
//
//  Created by Alankar Misra on 12/04/13.
//
//

#import "cocos2d.h"
#import "Constants.h"
#import "GameController.h"
#import "SimpleAudioEngine.h"


// Debug
FOUNDATION_EXPORT NSInteger const kDebugSimulationWaitTime;

// Game UI
FOUNDATION_EXPORT NSString *const kGameTextFont;

// Sound
FOUNDATION_EXPORT NSString *const kPopEffect;
FOUNDATION_EXPORT NSString *const kCorrectResponseEffect;
FOUNDATION_EXPORT NSString *const kIncorrectResponseEffect;
FOUNDATION_EXPORT NSString *const kBlockCompleteBackgroundMusic;
FOUNDATION_EXPORT NSString *const kMenuBackgroundMusic;
FOUNDATION_EXPORT NSString *const kSessionCompleteBackgroundMusic;

// Stimulus
FOUNDATION_EXPORT double const kFixationDurationMin;
FOUNDATION_EXPORT double const kFixationDurationMax;
FOUNDATION_EXPORT double const kExemplarDuration;
FOUNDATION_EXPORT double const kMaskDuration;
FOUNDATION_EXPORT double const kMorphDuration;
FOUNDATION_EXPORT double const kFeedbackDuration;
FOUNDATION_EXPORT double const kResponseDuration;
FOUNDATION_EXPORT double const kFadeDuration;

static inline ccColor4B getCocosBackgroundColor(void) {
    return ccc4(kBackgroundColorR, kBackgroundColorG, kBackgroundColorB, 255.0);
}

static inline void segueToScene(CCScene *scene) {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}

static inline CCMenuItem *getMenuButton(CCMenu *menu) {
    return [menu.children objectAtIndex:0];
}

static inline CGSize getWinSize(void) {
    return ([[CCDirector sharedDirector] winSize]);
}

static inline CGFloat getWinHeight(void) {
    return getWinSize().height;
}

static inline CGFloat getWinWidth(void) {
    return getWinSize().width;
}

static inline GameController *getGameController(void) {
    return (GameController *)([CCDirector sharedDirector].delegate);
}

static inline void playMenuBackgroundMusic(void) {
    dispatch_queue_t soundQueue = dispatch_queue_create("sound preloader", NULL);
    dispatch_async(soundQueue, ^ {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:kMenuBackgroundMusic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:kMenuBackgroundMusic];
        });
    });
}


typedef NS_ENUM(NSInteger, SessionType) {
    SessionTypeWarmup, // The warm up just before practice. BlockCompleteLayer will read this and direct the participant to a normal session.
    SessionTypeNormal, // A normal game session.
    SessionTypePractice // A practice session. BlockCompleteLayer will read this and direct the participant back to the menu.
};

// Response related constants
typedef NS_ENUM(NSInteger, ResponseType) {
    ResponseTypeNoResponse,
    ResponseTypeLeft,
    ResponseTypeRight
};

// Grading related constants
typedef NS_ENUM(NSInteger, GradeType) {
    GradeTypeNoResponse,
    GradeTypeCorrect,
    GradeTypeIncorrect
};
