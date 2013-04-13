//
//  ResponseLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CocosConstants.h"

@protocol ResponseLayerDelegate

-(void)didRespond:(ResponseType)response responseTime:(NSTimeInterval)responseTime;

@end

@interface ResponseLayer : CCLayer

@property (nonatomic, weak) id <ResponseLayerDelegate> delegate;
-(void)getResponse;
-(void)clear;

@end
