//
//  NSUserDefaults+Extensions.m
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import "Constants.h"
#import "NSUserDefaults+Extensions.h"

@implementation NSUserDefaults (Extensions)

// Default keys. Keys must be synchronous with Defaults.plist
#define DEFAULT_LOGGED_IN_PARTICIPANT_KEY @"LoggedInParticipant"
#define DEFAULT_BACKGROUND_SOUND_KEY @"BackgroundSound"
#define DEFAULT_SETTINGS_PASSWORD_KEY @"SettingsPassword"

-(void)login:(NSInteger)pid {
    [self setInteger:pid forKey:DEFAULT_LOGGED_IN_PARTICIPANT_KEY];
    [self synchronize];
}

-(void)logout {
    [self setInteger:0 forKey:DEFAULT_LOGGED_IN_PARTICIPANT_KEY]; // TODO: Why does this default to 0!!!
    [self synchronize];
}

-(BOOL)isLoggedIn:(NSInteger)pid {
    return self.loggedIn == pid;
}

-(NSInteger)loggedIn {
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
