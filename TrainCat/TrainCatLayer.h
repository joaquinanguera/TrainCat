//
//  HelloWorldLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "StimulusLayer.h"
#import "ResponseLayer.h"
#import "FeedbackLayer.h"


// HelloWorldLayer
// GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, 
@interface TrainCatLayer : CCLayerColor <StimulusLayerDelegate, ResponseLayerDelegate, FeedbackLayerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
