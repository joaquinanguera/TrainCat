//
//  CCMenu+Extensions.m
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import "CCMenu+Extension.h"
#import "cocos2d.h"
#import "FileUtils.h"

@implementation CCMenu (Extension)

+(CCMenuItemImage *)buttonWithImagePrefix:(NSString *)prefix tag:(NSInteger)tag target:(id)target selector:(SEL)selector {
    CCMenuItemImage *btnImage;
    if([[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@DisabledNormal.png", prefix]]) {
        btnImage = [CCMenuItemImage
                    itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@Normal.png", prefix]]
                    selectedSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@Selected.png", prefix]]
                    disabledSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@DisabledNormal.png", prefix]]
                    target:target
                    selector:selector];
    } else {
        btnImage = [CCMenuItemImage
                    itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@Normal.png", prefix]]
                    selectedSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@Selected.png", prefix]]
                    target:target
                    selector:selector];        
    }
    
    btnImage.tag = tag;
    return btnImage;
}

+(CCMenu *)menuWithImagePrefix:(NSString *)prefix tag:(NSInteger)tag target:(id)target selector:(SEL)selector {
    return [CCMenu menuWithItems:[self buttonWithImagePrefix:prefix tag:tag target:target selector:selector], nil];
}

+(CCMenu *)menuWithImagePrefixes:(NSArray *)prefixes tags:(NSArray *)tags target:(id)target selectors:(NSArray *)selectors {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:prefixes.count];
    for(NSInteger i=0, c=prefixes.count; i<c; ++i) {
        SEL selector = NSSelectorFromString(selectors.count > 1 ? selectors[i] : selectors[0]);
        [buttons addObject:[self buttonWithImagePrefix:prefixes[i] tag:tags?tags[i]:0 target:target selector:selector]];
    }
    
    return [CCMenu menuWithArray:buttons];
}

-(CCMenuItem *)button {
    return self.children.lastObject;
}

@end
