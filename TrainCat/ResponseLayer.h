//
//  ResponseLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ResponseLayerDelegate

// responseTag = RESPONSE_UNKNOWN, RESPONSE_LEFT or RESPONSE_RIGHT 
-(void)didRespond:(NSInteger)responseTag;

@end

@interface ResponseLayer : CCLayer

@property (nonatomic, weak) id <ResponseLayerDelegate> delegate;
-(void)getResponse;

@end
