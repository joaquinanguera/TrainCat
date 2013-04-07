//
//  HUDLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "HUDLayer.h"
#import "constants.h"

@interface HUDLayer()

@property (nonatomic, strong) CCLabelTTF *label;

@end

@implementation HUDLayer

#define PADDING 20

-(id)init
{
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.label = [CCLabelTTF labelWithString:@"" fontName:GAME_TEXT_FONT fontSize:18];
        self.label.color = ccc3(0, 0, 0);
        self.label.position = ccp(self.label.contentSize.width/2.0 + PADDING, winSize.height - self.label.contentSize.height/2 - PADDING );
        [self addChild:self.label];
    }
    
    return self;
}

-(void)setParticipantName:(NSString *)participantName {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.label.string = participantName;
    self.label.position = ccp(self.label.contentSize.width/2.0 + PADDING, winSize.height - self.label.contentSize.height/2 - PADDING );
}

-(void)clear {
    // Do nothing
}

@end
