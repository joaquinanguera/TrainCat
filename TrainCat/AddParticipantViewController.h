//
//  AddParticipantViewController.h
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import <UIKit/UIKit.h>
#import "Participant+Extension.h"

@protocol AddParticipantViewControllerDelegate;

@interface AddParticipantViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Participant *participant;
@property (nonatomic, weak) id <AddParticipantViewControllerDelegate> delegate;

-(void)showErrorWithMessage:(NSString *)message title:(NSString *)title;

@end


@protocol AddParticipantViewControllerDelegate
-(void)addParticipantViewControllerDidSave:(AddParticipantViewController*)controller participant:(Participant*)participant autoLogin:(BOOL)autoLogin;
-(void)addParticipantViewControllerDidCancel:(AddParticipantViewController*)controller participant:(Participant *)participant;
@end