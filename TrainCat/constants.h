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

// Commonly used references
#define APP_DELEGATE ((AppController *)[[UIApplication sharedApplication] delegate])
#define MOC ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext


#define BACKGROUND_COLOR ccc4(144, 217, 232, 255)

#define MAX_TRIALS_PER_STIMULUS_BLOCK 36
#define MAX_TRIALS_PER_PRACTICE_BLOCK 6
#define MAX_STIMULUS_BLOCKS 6
#define MAX_STIMULUS_LEVEL 10

#define STIMULUS_PADDING 15.0
#define STIMULUS_BAR_PADDING_TOP 40.0

#define DEMO_PARTICIPANT_ID -1

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
