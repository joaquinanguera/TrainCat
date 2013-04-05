//
//  ParticipantDetailViewController.h
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import <UIKit/UIKit.h>
#import "Participant+Extension.h"

@protocol ParticipantDetailViewControllerDelegate;

@interface ParticipantDetailViewController : UIViewController

@property (nonatomic, strong) Participant *participant;
@property (nonatomic, weak) id <ParticipantDetailViewControllerDelegate> delegate;

@end


@protocol ParticipantDetailViewControllerDelegate
-(void)participantDetailViewControllerDidSave:(Participant *)participant withAutoLogin:(BOOL)autoLogin;
-(void)participantDetailViewControllerDidReturn:(Participant *)participant;
@end
