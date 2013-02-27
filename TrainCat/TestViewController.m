//
//  TestViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 24/02/13.
//
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "Participant.h"

@interface TestViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    for(int i=0; i<10; ++i) {
        [self insertParticipant:[NSString stringWithFormat:@"Participant %d", arc4random()] withPassword:@"password"];
    }
}

- (void)insertParticipant:(NSString *)pid withPassword:(NSString *)password {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *participantEntity = [[self.fetchedResultsController fetchRequest] entity];
    Participant *newParticipant = [NSEntityDescription insertNewObjectForEntityForName:[participantEntity name] inManagedObjectContext:context];
    newParticipant.pid = pid;
    newParticipant.password = password;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"Successfully created and saved object. %d objects in store.", [self.fetchedResultsController.fetchedObjects count]);
    }
}

- (IBAction)didClickInsert {
    [self insertParticipant:[NSString stringWithFormat:@"Participant %d", arc4random()] withPassword:@"password"];
}

- (IBAction)didClickEdit {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0]; // We are only concerned with the first record
    Participant *participant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    participant.pid = @"alankarmisra - modified";
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"Successfully updated objects in store.");
    }
}

- (IBAction)didClickDelete {
    // Deletes the top row
    if([self.fetchedResultsController.fetchedObjects count]) {
        NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        Participant *participant = [self.fetchedResultsController objectAtIndexPath:indexPath]; // We are only concerned with the first record
        [context deleteObject:participant];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"%d records remaining", [self.fetchedResultsController.fetchedObjects count]);
        }
    } else {
        NSLog(@"Nothing to delete.");
    }
}

- (IBAction)didClickDisplay {
    if([self.fetchedResultsController.fetchedObjects count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        Participant *participant = [self.fetchedResultsController objectAtIndexPath:indexPath]; // We are only concerned with the first record
        NSLog(@"%d records", [self.fetchedResultsController.fetchedObjects count]);
        NSLog(@"pid: %@", participant.pid);
    } else {
        NSLog(@"Nothing to display");
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20]; // This will really speed things up!!!
                
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pid" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Participant"];  
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
        
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        _managedObjectContext = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }    
    return _managedObjectContext;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
@end
