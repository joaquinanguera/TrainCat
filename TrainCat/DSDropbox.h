//
//  DropboxController.h
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import <Foundation/Foundation.h>

@interface DSDropbox : NSObject

+(void)writeToFile:(NSString *)path theString:(NSString *)string;
+(void)linkWithDelegate:(UIViewController *)controller;
+(void)unlinkWithDelegate:(UIViewController *)controller;
@end
