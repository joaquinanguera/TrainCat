//
//  CocosViewController.m
//  TrainCat
//
//  Created by Alankar Misra on 14/02/13.
//
//

#import "GameController.h"
#import "TrainCatLayer.h"

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
    NSLog(@"viewDidLoad");
    
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
        [director replaceScene:[TrainCatLayer scene]];
    else
        [director runWithScene:[TrainCatLayer scene]];
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

/*
 // Create the main window
 window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
 
 // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
 CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
 pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
 depthFormat:0	//GL_DEPTH_COMPONENT24_OES
 preserveBackbuffer:NO
 sharegroup:nil
 multiSampling:NO
 numberOfSamples:0];
 
 director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
 
 director_.wantsFullScreenLayout = YES;
 
 // Display FSP and SPF
 [director_ setDisplayStats:YES];
 
 // set FPS at 60
 [director_ setAnimationInterval:1.0/60];
 
 // attach the openglView to the director
 [director_ setView:glView];
 
 // for rotation and other messages
 [director_ setDelegate:self];
 
 // 2D projection
 [director_ setProjection:kCCDirectorProjection2D];
 //	[director setProjection:kCCDirectorProjection3D];
 
 // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
 if( ! [director_ enableRetinaDisplay:YES] )
 CCLOG(@"Retina Display Not supported");
 
 // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
 // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
 // You can change anytime.
 [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
 
 // If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
 // On iPad HD  : "-ipadhd", "-ipad",  "-hd"
 // On iPad     : "-ipad", "-hd"
 // On iPhone HD: "-hd"
 CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
 [sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
 [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
 [sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
 [sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
 
 // Assume that PVR images have premultiplied alpha
 [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
 
 // and add the scene to the stack. The director will run it when it automatically when the view is displayed.
 [director_ pushScene: [IntroLayer scene]];
 
 
 // Create a Navigation Controller with the Director
 navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
 navController_.navigationBarHidden = YES;
 
 // set the Navigation Controller as the root view controller
 //	[window_ addSubview:navController_.view];	// Generates flicker.
 [window_ setRootViewController:navController_];
 
 // make main window visible
 [window_ makeKeyAndVisible];
 */
