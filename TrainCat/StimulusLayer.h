//
//  StimlusLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol StimulusLayerDelegate

-(void)stimulusDidFinish;

@end

@interface StimulusLayer : CCLayer

@property (nonatomic, weak) id <StimulusLayerDelegate> delegate;
-(void)showStimulusWithExemplarLeftPath:(NSString *)exemplarLeftPath exemplarRightPath:(NSString *)exemplarRightPath morphPath:(NSString *)morphPath;

@end
