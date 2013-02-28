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
    
    /*
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attempted to write"
     message:[[NSString alloc] initWithFormat:@"Created file %@ on DropBox.", path]
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */

    NSLog(@"Created file %@ on DropBox.", path);
}

+(void)linkWithDelegate:(UIViewController *)controller {
    DBAccountManager *dbm = [DBAccountManager sharedManager];
    /*
    [dbm addObserver:nil block:^(DBAccount *account) {
        NSLog(@"Done");
        if(account && [account isLinked]) {
            NSLog(@"Authenticated from within DSDropbox");
        } else {
            NSLog(@"NOT Authenticated from within DSDropbox");
        }
    }];*/
    [dbm linkFromController:controller];
}

+(void)unlinkWithDelegate:(UIViewController *)controller {
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
}

@end
