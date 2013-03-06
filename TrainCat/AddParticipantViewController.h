//
//  AddParticipantViewController.h
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import <UIKit/UIKit.h>
#import "Participant.h"

@protocol AddParticipantViewControllerDelegate;

@interface AddParticipantViewController : UIViewController

@property (nonatomic, strong) Participant *participant;
@property (nonatomic, weak) id <AddParticipantViewControllerDelegate> delegate;

@end


@protocol AddParticipantViewControllerDelegate
-(void)addParticipantViewControllerDidSave:(Participant*)participant withAutoLogin:(BOOL)autoLogin;
-(void)addParticipantViewControllerDidCancel:(Participant *)participant;
@end