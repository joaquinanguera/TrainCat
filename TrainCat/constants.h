//
//  constants.h
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#ifndef TrainCat_constants_h
#define TrainCat_constants_h

#define MAX_TRIALS_PER_STIMULUS_BLOCK 36

#define STIMULUS_PADDING 15.0
#define STIMULUS_BAR_PADDING_TOP 40.0

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
