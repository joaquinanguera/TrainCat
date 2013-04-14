//
//  Constants.h
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#ifndef TrainCat_constants_h
#define TrainCat_constants_h

#import "AppDelegate.h"

//#define DDEBUG 1

// Dropbox
FOUNDATION_EXPORT NSString *const kDropboxAppKey;
FOUNDATION_EXPORT NSString *const kDropboxSecretKey;
FOUNDATION_EXPORT NSString *const kDropboxLinkAttemptComplete;

// Game UI
FOUNDATION_EXPORT NSString *const kGameTextFont;


// Participant
FOUNDATION_EXPORT NSInteger const kDemoParticipantId;
FOUNDATION_EXPORT NSInteger const kMinParticipantId;
FOUNDATION_EXPORT NSInteger const kMaxParticipantId;

// Program
FOUNDATION_EXPORT NSInteger const kMaxTrialsPerBlock;
FOUNDATION_EXPORT NSInteger const kMaxTrialsPerPracticeBlock;
FOUNDATION_EXPORT NSInteger const kMaxBlocks;
FOUNDATION_EXPORT NSInteger const kMaxLevel;
FOUNDATION_EXPORT NSInteger const kMaxSessions;


// Utility functions
static double const kBackgroundColorR = 127.0;
static double const kBackgroundColorG = 200.0;
static double const kBackgroundColorB = 200.0;

static inline UIColor *getBackgroundColor(void) {
    return [UIColor colorWithRed:kBackgroundColorR/255.0 green:kBackgroundColorG/255.0 blue:kBackgroundColorB/255.0 alpha:255];
}

static inline AppController *getAppDelegate(void) {
    return ((AppController *)[[UIApplication sharedApplication] delegate]);
    
}

static inline NSManagedObjectContext *getMOC(void) {
    return ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}


#endif
