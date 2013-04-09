//
//  CCNode+Extension.h
//  TrainCat
//
//  Created by Alankar Misra on 09/04/13.
//
//

#import "CCNode.h"

@interface CCNode (Extension)

+(CGFloat)reflectXAround:(CGFloat)x reference:(CCNode *)reference;
+(CGFloat)reflectYAround:(CGFloat)y reference:(CCNode *)reference;

-(CCNode *)shiftLeft:(CGFloat)value;
-(CCNode *)shiftRight:(CGFloat)value;
-(CCNode *)shiftUp:(CGFloat)value;
-(CCNode *)shiftDown:(CGFloat)value;

-(CCNode *)alignTop;
-(CCNode *)alignLeft;
-(CCNode *)alignBottom;
-(CCNode *)alignRight;
-(CCNode *)alignCenter;
-(CCNode *)alignMiddle;

-(CCNode *)alignTopTo:(CCNode *)reference;
-(CCNode *)alignLeftTo:(CCNode *)reference;
-(CCNode *)alignBottomTo:(CCNode *)reference;
-(CCNode *)alignRightTo:(CCNode *)reference;
-(CCNode *)alignCenterTo:(CCNode *)reference;
-(CCNode *)alignMiddleTo:(CCNode *)reference;

@end
