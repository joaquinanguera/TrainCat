//
//  HUDLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer

@property (nonatomic, copy) NSString *participantName;
-(void)clear;

@end
