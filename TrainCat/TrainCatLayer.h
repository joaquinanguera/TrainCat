//
//  TrainCatLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


#import "cocos2d.h"
#import "StimulusLayer.h"
#import "ResponseLayer.h"
#import "FeedbackLayer.h"
#import "Participant+Extension.h"

@interface TrainCatLayer : CCLayerColor <StimulusLayerDelegate, ResponseLayerDelegate, FeedbackLayerDelegate>
{
}

// returns a CCScene that contains the TrainCatLayer as the only child
+(CCScene *) sceneWithSessionType:(SessionType)sessionType;

@end
