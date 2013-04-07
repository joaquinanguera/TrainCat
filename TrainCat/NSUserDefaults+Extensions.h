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
-(NSInteger)loggedIn;
-(void)login:(NSInteger)pid;
-(void)logout;
-(BOOL)isLoggedIn:(NSInteger)pid;
-(void)setSound:(BOOL)state;
-(BOOL)sound;
-(NSString *)settingsPassword;
-(void)setSettingsPassword:(NSString *)password;

@end
