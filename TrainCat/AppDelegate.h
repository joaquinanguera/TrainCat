//
//  AppDelegate.h
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : UIResponder <UIApplicationDelegate, CCDirectorDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
