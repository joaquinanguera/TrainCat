//
//  CocosViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 14/02/13.
//
//

#import "GameController.h"
#import "IntroLayer.h"

@interface GameController ()

@end

@implementation GameController

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
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        CGRect bounds = [[[UIApplication sharedApplication] keyWindow] bounds];        
        CGRect horizontalBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
        
        // Create the OpenGL view that Cocos2D will render to.
        
        CCGLView *glView = [CCGLView viewWithFrame:horizontalBounds
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        // glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // Assign the view to the director.
        director.view = glView;

        // Initialize other director settings.
        [director setAnimationInterval:1.0f/60.0f];
        [director enableRetinaDisplay:YES];
    }
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    if(director.runningScene)
        [director replaceScene:[IntroLayer scene]];
    else
        [director runWithScene:[IntroLayer scene]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

