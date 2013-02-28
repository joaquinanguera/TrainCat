//
//  AppDelegate.h
//  TrainCat
//
//  Created by Alankar Misra on 07/02/13.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : UIResponder <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	//CCDirectorIOS	*director_;							// weak ref
    CCDirectorIOS	*__unsafe_unretained director_;	// weak ref
}

//@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, strong) UIWindow *window;
@property (readonly) UINavigationController *navController;
//@property (readonly) CCDirectorIOS *director;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
