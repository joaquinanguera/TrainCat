//
//  DropboxController.h
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import <Foundation/Foundation.h>

@interface DropboxController : NSObject

+(void)writeToFile:(NSString *)path theString:(NSString *)string;

@end
