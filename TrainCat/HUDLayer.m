//
//  HUDLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

#define PADDING 20

-(id)init
{
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"[ Demo Mode ]" fontName:@"DevanagariSangamMN-Bold" fontSize:18];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(label.contentSize.width/2.0 + PADDING, winSize.height - label.contentSize.height/2 - PADDING );
        [self addChild:label];
    }
    
    return self;
}

@end
