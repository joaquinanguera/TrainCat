//
//  DropboxController.m
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import "DSDropbox.h"
#import <Dropbox/Dropbox.h>

@implementation DSDropbox

+(void)writeToFile:(NSString *)path theString:(NSString *)string; {
    DBPath *newPath = [[DBPath root] childPath:path];
    DBFile *file;
    
    if(!(file = [[DBFilesystem sharedFilesystem] openFile:newPath error:nil])) {
        NSLog(@"File does not exist. Creating...");
        file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
    }
    
    [file writeString:string error:nil];
    NSLog(@"Created file %@ on DropBox.", path);
}

+(void)linkWithDelegate:(UIViewController *)controller {
    [[DBAccountManager sharedManager] linkFromController:controller.navigationController.viewControllers[0]];
}

+(void)unlinkWithDelegate:(UIViewController *)controller {
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
}

+(DBAccountInfo *)accountInfo {
    return [[[DBAccountManager sharedManager] linkedAccount] info];
}

@end
