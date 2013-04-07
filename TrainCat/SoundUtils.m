//
//  SoundUtils.m
//  TrainCat
//
//  Created by Alankar Misra on 07/04/13.
//
//

#import <AudioToolbox/AudioToolbox.h>
#import "SoundUtils.h"

@implementation SoundUtils

+(void)playInputClick {
    AudioServicesPlaySystemSound(0x450);    
}

/*
+(void)playInputClickLoud {
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesDisposeSystemSoundID(soundID);    
}
 */

@end
