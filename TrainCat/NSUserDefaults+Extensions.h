//
//  NSUserDefaults+Extensions.h
//  TrainCat
//
//  Created by Alankar Misra on 05/04/13.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extensions)

// Participant related functions
-(int32_t)loggedIn;
-(void)login:(int32_t)pid;
-(void)logout;
-(BOOL)isLoggedIn:(int32_t)pid;
-(void)setSound:(BOOL)state;
-(BOOL)sound;
-(NSString *)settingsPassword;
-(void)setSettingsPassword:(NSString *)password;

@end
