//
//  NSUserDefaults+Extensions.m
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import "constants.h"
#import "NSUserDefaults+Extensions.h"

@implementation NSUserDefaults (Extensions)

-(void)login:(int32_t)pid {
    [self setInteger:pid forKey:DEFAULT_LOGGED_IN_PARTICIPANT_KEY];
    [self synchronize];
}

-(void)logout {
    [self setInteger:0 forKey:DEFAULT_LOGGED_IN_PARTICIPANT_KEY]; // TODO: Why does this default to 0!!!
    [self synchronize];
}

-(BOOL)isLoggedIn:(int32_t)pid {
    return self.loggedIn == pid;
}

-(int32_t)loggedIn {
    return [self integerForKey:DEFAULT_LOGGED_IN_PARTICIPANT_KEY];
}

-(void)setSound:(BOOL)state {
    [self setBool:state forKey:DEFAULT_BACKGROUND_SOUND_KEY];
}

-(BOOL)sound {
    return [self boolForKey:DEFAULT_BACKGROUND_SOUND_KEY];
}

-(NSString *)settingsPassword {
    return [self stringForKey:DEFAULT_SETTINGS_PASSWORD_KEY];
}

-(void)setSettingsPassword:(NSString *)password {
    [self setObject:password forKey:DEFAULT_SETTINGS_PASSWORD_KEY];
}


@end
