//
//  ParticipantTableViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import "ParticipantMasterViewController.h"
#import "ParticipantDetailViewController.h"
#import "AppDelegate.h"
#import "Participant+Extension.h"
#import "constants.h"
#import "NSUserDefaults+Extensions.h"

@interface ParticipantMasterViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ParticipantMasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [segue identifier];
    
    if([identifier isEqualToString:@"addParticipant"]) {
        Participant *newParticipant = [NSEntityDescription
                                       insertNewObjectForEntityForName:[[[self.fetchedResultsController fetchRequest] entity] name]
                                       inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
        AddParticipantViewController *apvc = [segue destinationViewController];
        apvc.participant = newParticipant;
        apvc.delegate = self;
    } else if([identifier isEqualToString:@"viewEditParticipant"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Participant *participant = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        ParticipantDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.participant = participant;
        detailViewController.delegate = self;
    }
    
}

#pragma mark Add Participant View Delegate Methods

-(void)addParticipantViewControllerDidSave:(AddParticipantViewController*)controller participant:(Participant*)participant autoLogin:(BOOL)autoLogin {
    NSError *error = nil;
    if (![self.fetchedResultsController.managedObjectContext save:&error]) {
        [controller showErrorWithMessage:[error domain] title:@"Failed to create new participant"];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        if(autoLogin) {
            [[NSUserDefaults standardUserDefaults] login:participant.pid];
        }
        [self.tableView reloadData];
    }
}

-(void)addParticipantViewControllerDidCancel:(AddParticipantViewController*)controller participant:(Participant *)participant {
    [self.fetchedResultsController.managedObjectContext deleteObject:participant];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Edit Participant View Delegate Methods
-(void)didLoginNewUserWithId:(NSInteger)pid previousPid:(NSInteger)previousPid {
    [self.tableView reloadData]; // Madly inefficient but ok
}

-(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        _managedObjectContext = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _managedObjectContext;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    /*
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_R/255 green:BACKGROUND_COLOR_G/255 blue:BACKGROUND_COLOR_B/255 alpha:1.0];
    cell.selectedBackgroundView = selectionColor; */
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // Why doesn't this do anything for the add editing style? or the edit? or is that handled elsewhere?
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSNumber *pid = [NSNumber numberWithInt:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid>%@", pid];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]; // @"Participant" TODO: Cache this when you're done testing
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Participant *participant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] isLoggedIn:participant.pid];
    cell.textLabel.text = isLoggedIn ? [NSString stringWithFormat:@"%04d (Playing)", participant.pid] : [NSString stringWithFormat:@"%04d", participant.pid];
}


@end
