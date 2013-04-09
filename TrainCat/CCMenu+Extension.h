//
//  CCMenu+Extensions.h
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import "CCMenu.h"

@interface CCMenu (Extension)

+(CCMenuItemImage *)buttonWithImagePrefix:(NSString *)prefix tag:(NSInteger)tag target:(id)target selector:(SEL)selector;
+(CCMenu *)menuWithImagePrefix:(NSString *)prefix tag:(NSInteger)tag target:(id)target selector:(SEL)selector;
+(CCMenu *)menuWithImagePrefixes:(NSArray *)prefixes tags:(NSArray *)tags target:(id)target selectors:(NSArray *)selectors;
-(CCMenuItem *)button;

@end
