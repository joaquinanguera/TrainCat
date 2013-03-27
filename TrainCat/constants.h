//
//  constants.h
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#ifndef TrainCat_constants_h
#define TrainCat_constants_h

#define MAX_TRIALS_PER_STIMULUS_BLOCK 5

// Stimulus related constants
#define EXEMPLAR_TAG 1
#define MORPH_TAG 2
#define STIMULUS_PADDING 15

// Durations in seconds
#define FIXATION_DURATION_MIN 1.0f
#define FIXATION_DURATION_MAX 2.0f
#define EXEMPLAR_DURATION 2.0f
#define MASK_DURATION 250.0/1000.0
#define MORPH_DURATION 2.0f
#define FEEDBACK_DURATION 500.0/1000.0
#define RESPONSE_DURATION 2.0f

// Response related constants
#define RESPONSE_SKIPPED 0
#define RESPONSE_LEFT 1
#define RESPONSE_RIGHT 2

// Grading related constants
#define GRADE_RESPONSE_SKIPPED 0
#define GRADE_CORRECT 1
#define GRADE_INCORRECT 2


#endif
