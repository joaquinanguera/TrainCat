//
//  SessionManager.m
//  TrainCat
//
//  Created by Alankar Misra on 06/03/13.
//
//

#import "SessionManager.h"


@implementation SessionManager

#define LOGIN_KEY @"LOGIN_KEY"

+(void)login:(int32_t)pid {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:pid forKey:LOGIN_KEY];
    [ud synchronize];
}

+(void)logout {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:LOGIN_KEY];
    [ud synchronize];
}

+(BOOL)isLoggedIn:(int32_t)pid {
    return self.loggedIn == pid;
}

+(int32_t)loggedIn {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:LOGIN_KEY];
}

@end
