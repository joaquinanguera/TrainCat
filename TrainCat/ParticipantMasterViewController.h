//
//  ParticipantTableViewController.h
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddParticipantViewController.h"

@interface ParticipantMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddParticipantViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
