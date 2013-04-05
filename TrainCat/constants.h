//
//  constants.h
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#ifndef TrainCat_constants_h
#define TrainCat_constants_h

#define DDEBUG 1
#define DEBUG_SIMULATION_WAIT_TIME 2

// Dropbox related constants
#define DROPBOX_APP_KEY @"ev7wggh9l3s2vy7"
#define DROPBOX_SECRET @"bgoed4lggdhkuke"
#define DS_DROPBOX_LINK_ATTEMPT_COMPLETE @"DS_DROPBOX_LINK_ATTEMPT_COMPLETE"

// Commonly used references
#define APP_DELEGATE ((AppController *)[[UIApplication sharedApplication] delegate])
#define MOC ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext

// Default keys. Keys must be synchronous with Defaults.plist
#define DEFAULT_LOGGED_IN_PARTICIPANT_KEY @"LoggedInParticipant"
#define DEFAULT_BACKGROUND_SOUND_KEY @"BackgroundSound"
#define DEFAULT_SETTINGS_PASSWORD_KEY @"SettingsPassword"

// Background color constants
#define BACKGROUND_COLOR_R 127.0
#define BACKGROUND_COLOR_G 200.0
#define BACKGROUND_COLOR_B 200.0
#define BACKGROUND_COLOR ccc4(BACKGROUND_COLOR_R, BACKGROUND_COLOR_G, BACKGROUND_COLOR_B, 255)

#define MAX_TRIALS_PER_STIMULUS_BLOCK 36
#define MAX_TRIALS_PER_PRACTICE_BLOCK 6
#define MAX_STIMULUS_BLOCKS 6
#define MAX_STIMULUS_LEVEL 10

#define STIMULUS_PADDING 15.0
#define STIMULUS_BAR_PADDING_TOP 40.0

#define DEMO_PARTICIPANT_ID 0
#define MIN_PARTICIPANT_ID 1
#define MAX_PARTICIPANT_ID 9999

#define START_MENU_TAG 1

// Durations in seconds
#define FIXATION_DURATION_MIN 1.0
#define FIXATION_DURATION_MAX 2.0
#define EXEMPLAR_DURATION 2.0
#define MASK_DURATION 250.0/1000
#define MORPH_DURATION 2.0
#define FEEDBACK_DURATION 500.0/1000
#define RESPONSE_DURATION 2.0
#define FADE_DURATION 125.0/1000

typedef NS_ENUM(NSInteger, StimulusType) {
    StimulusTypeFixation,
    StimulusTypeExemplar,
    StimulusTypeMorph,
    StimulusTypeMask
};

typedef NS_ENUM(NSInteger, StimulusZIndex) { // Order significant
    StimulusZIndexExemplar,
    StimulusZIndexMask,
    StimulusZIndexFixation,
    StimulusZIndexMorph
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


#endif
