//
//  StimlusLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol StimulusLayerDelegate

-(void)stimulusDidFinish;

@end

@interface StimulusLayer : CCLayer

@property (nonatomic, weak) id <StimulusLayerDelegate> delegate;
-(void)showStimulusWithExemplarLeftPath:(NSString *)exemplarLeftPath exemplarRightPath:(NSString *)exemplarRightPath morphLabel:(NSString *)morphLabel;
-(void)clear;

@end
