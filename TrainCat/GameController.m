//
//  CocosViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 14/02/13.
//
//

#import "GameController.h"
#import "IntroLayer.h"
#import "DSDropbox.h"
#import "CocosConstants.h"
#import "SessionCompleteLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        director.view = [self createDirectorGLView];
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
    CCScene * scene = [IntroLayer scene];
    if(director.runningScene)
        [director replaceScene:scene];
    else
        [director runWithScene:scene];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Observe some notifications so we can properly instruct the director.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationSignificantTimeChange:)
                                                 name:UIApplicationSignificantTimeChangeNotification
                                               object:nil];
    
    
    CCScene *scene = [CCDirector sharedDirector].runningScene;
    for(CCNode *child in scene.children) {
        if([child respondsToSelector:@selector(viewWillAppear)]) {
            [child performSelector:@selector(viewWillAppear)];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];    
    [[CCDirector sharedDirector] setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
    [[CCDirector sharedDirector] purgeCachedData];
}


#pragma mark - Setting up the director

- (CCGLView *)createDirectorGLView
{

    CGRect bounds = [[[UIApplication sharedApplication] keyWindow] bounds];
    CGRect horizontalBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width); // height and width swapped
    
    // Create the OpenGL view that Cocos2D will render to.
    CCGLView *glView = [CCGLView viewWithFrame:horizontalBounds
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    return glView;
}

#pragma mark - Notification handlers

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];    
    [[CCDirector sharedDirector] pause];
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] resume];
    if([[[CCDirector sharedDirector] runningScene].children.lastObject isKindOfClass:[SessionCompleteLayer class]]) {
        NSLog(@"Going to main menu");
        [self performSelector:@selector(goToMainMenu) withObject:self afterDelay:1.0];
    }
}

-(void)goToMainMenu {
    segueToScene([IntroLayer scene]);
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] stopAnimation];
}


- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] startAnimation];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    [SimpleAudioEngine end];
    [[CCDirector sharedDirector] end];
}


- (void)applicationSignificantTimeChange:(NSNotification *)notification
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


@end

