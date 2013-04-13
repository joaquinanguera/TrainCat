//
//  CCNode+Extension.m
//  TrainCat
//
//  Created by Alankar Misra on 09/04/13.
//
//

// TODO: This could be converted into a more full featured layout manager. 

#import "cocos2d.h"
#import "CocosConstants.h"
#import "CCNode+Extension.h"

@implementation CCNode (Extension)

+(CGFloat)reflectXAround:(CGFloat)x reference:(CCNode *)reference {
    return ((reference ? reference.contentSize.width : [CCDirector sharedDirector].winSize.width) - x);
}

+(CGFloat)reflectYAround:(CGFloat)y reference:(CCNode *)reference {
    return ((reference ? reference.contentSize.height : [CCDirector sharedDirector].winSize.height) - y);
}

-(CCNode *)alignLeftTo:(CCNode *)reference {
    self.position = ccp([self halfSize].x, self.position.y);
    return self;
}

-(CCNode *)alignLeft {
    return [self alignLeftTo:nil];
}

-(CCNode *)alignBottomTo:(CCNode *)reference {
    self.position = ccp(self.position.x, [self halfSize].y);
    return self;
}

-(CCNode *)alignBottom {
    return [self alignBottomTo:nil];
}

-(CCNode *)alignRightTo:(CCNode *)reference {
    self.position = ccp([CCNode reflectXAround:[self halfSize].x reference:reference], self.position.y);
    return self;
}

-(CCNode *)alignRight {
    return [self alignRightTo:nil];
}

-(CCNode *)alignTopTo:(CCNode *)reference {
    self.position = ccp(self.position.x, [CCNode reflectYAround:[self halfSize].y reference:reference]);
    return self;
}

-(CCNode *)alignTop {
    return [self alignTopTo:nil];
}

-(CCNode *)alignCenterTo:(CCNode *)reference {
    self.position = ccp((reference ? reference.contentSize.width : [CCDirector sharedDirector].winSize.width)/2.0, self.position.y);
    return self;
}

-(CCNode *)alignCenter {
    return [self alignCenterTo:nil];
}

-(CCNode *)alignMiddleTo:(CCNode *)reference {
    self.position = ccp(self.position.x,(reference ? reference.contentSize.height : [CCDirector sharedDirector].winSize.height)/2.0);
    return self;
}

-(CCNode *)alignMiddle {
    return [self alignMiddleTo:nil];
}

-(CCNode *)shiftLeft:(CGFloat)value {
    self.position = ccpSub(self.position, ccp(value,0));
    return self;
}

-(CCNode *)shiftRight:(CGFloat)value {
    self.position = ccpAdd(self.position, ccp(value,0));
    return self;
}

-(CCNode *)shiftUp:(CGFloat)value {
    self.position = ccpAdd(self.position, ccp(0,value));
    return self;
}

-(CCNode *)shiftDown:(CGFloat)value {
    self.position = ccpSub(self.position, ccp(0,value));
    return self;
}

-(CGPoint)halfSize {    
    return [self isKindOfClass:[CCMenu class]] ? getMenuButton((CCMenu*)self).anchorPointInPoints : self.anchorPointInPoints;
}


@end
