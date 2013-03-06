//
//  SessionManager.h
//  TrainCat
//
//  Created by Alankar Misra on 06/03/13.
//
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

+(int32_t)loggedIn;
+(void)login:(int32_t)pid;
+(void)logout;
+(BOOL)isLoggedIn:(int32_t)pid;

@end
