//
//  SpriteUtils.m
//  TrainCat
//
//  Created by Alankar Misra on 26/03/13.
//
//

#import "SpriteUtils.h"
#import "cocos2d.h"

@implementation SpriteUtils

+ (CCSprite*)blankSpriteWithSize:(CGSize)size
{
    CCSprite *sprite = [CCSprite node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer[i]=255;}
    CCTexture2D *tex = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSize:size];
    [sprite setTexture:tex];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    free(buffer);
    return sprite;
}

@end
