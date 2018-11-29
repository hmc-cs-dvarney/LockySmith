//
//  AppDelegate.m
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright Dalton 2014. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "MenuLayer.h"






#import "Global.h"

@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait;
	
	// iPad only
	return UIInterfaceOrientationMaskPortrait;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [MenuLayer scene]];
	}
}
@end


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[self initGameCenter];
    
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    if (CC_CONTENT_SCALE_FACTOR() == 2)
        g_fScaleR = 2.0f;
    [self setGlobal];

	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
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
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
    [self admobBanner];
	
	return YES;
}
-(void)setGlobal
{
    g_frmHero = [[CCAnimation alloc] init];
    g_frmHero.delayPerUnit = 0.2f;
    for(int i = 1; i<5; i++){
        [g_frmHero addSpriteFrameWithFilename:[NSString stringWithFormat:@"char%d.png", i]];
    }

}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];	
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}

-(void ) showInterstitial
{
    admobInterstitial = [[GADInterstitial alloc] init];
    admobInterstitial.adUnitID = @"ca-app-pub-9469259429528180/1662702950";
    admobInterstitial.delegate = self;
    [admobInterstitial loadRequest:[GADRequest request]];
    [admobInterstitial presentFromRootViewController: navController_];
}

-(void ) admobBanner
{
//    m_admobBanner = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
//    m_admobBanner.adUnitID = @"ca-app-pub-9582765200496501/2031947275";
//    
//    // Let the runtime know which UIViewController to restore after taking
//    // the user wherever the ad goes and add it to the view hierarchy.
//    
//    m_admobBanner.rootViewController = navController_;
//    [navController_.view addSubview:m_admobBanner];
//    [m_admobBanner loadRequest:[GADRequest request]];
    
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Create a view of the standard size at the bottom of the screen.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        m_admobBanner = [[GADBannerView alloc]
                          initWithFrame:CGRectMake(winSize.width/2-160,
                                                   winSize.height -
                                                   GAD_SIZE_320x50.height*3 + 100,
                                                   GAD_SIZE_320x50.width,
                                                   GAD_SIZE_320x50.height)];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        m_admobBanner.adUnitID = @"ca-app-pub-9469259429528180/9185969755";
    }
    
    else {
        m_admobBanner = [[GADBannerView alloc]
                          initWithFrame:CGRectMake(winSize.width/2-364,
                                                   winSize.height -
                                                   GAD_SIZE_728x90.height*3 + 178,
                                                   GAD_SIZE_728x90.width,
                                                   GAD_SIZE_728x90.height)];
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        m_admobBanner.adUnitID = @"ca-app-pub-9469259429528180/9185969755";
    }
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    m_admobBanner.rootViewController = navController_;
    
    [navController_.view addSubview:m_admobBanner];
    
    [m_admobBanner loadRequest:[GADRequest request]];
}

- (BOOL)initGameCenter {
    
	if(self.gameCenterManager != nil)
		return NO;
    self.currentLeaderBoard = LEADERBOARD_ID;
    
	if ([GameCenterManager isGameCenterAvailable])
	{
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
        return YES;
	}
    else
    {
        NSString *message = @"This IOS version is not available Game Center.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message!" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    }
    
    return NO;
}

- (void) showLeaderboard{
	GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardViewController != NULL) {
		leaderboardViewController.category = self.currentLeaderBoard;
		leaderboardViewController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardViewController.leaderboardDelegate = self;
        
        [self.navController presentModalViewController:leaderboardViewController animated:YES];
        
	}
}

- (void) showAchievements{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL){
		achievements.achievementDelegate = self;
		[self.navController presentModalViewController: achievements animated: YES];
	}
}

- (void)submitScore: (int) uploadScore{
	if( uploadScore > 0){
        
        if ([GameCenterManager isGameCenterAvailable]) {
            [self.gameCenterManager reportScore:uploadScore  forCategory: self.currentLeaderBoard];
            [self.gameCenterManager reloadHighScoresForCategory:self.currentLeaderBoard];
        }
	}
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[self.navController dismissModalViewControllerAnimated:YES];
    [viewController release];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self.navController dismissModalViewControllerAnimated:YES];
    [viewController release];
}

#pragma makr GameCenterManager protocol

- (void) scoreReported: (NSError*) error
{
    NSString *message = @"Score submited succesfully to Game Center.";
       // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles: nil];
       // alert.tag = 1;
       //[alert show];
      // [alert release];
    NSLog(@"%@", message);
}

- (void) processGameCenterAuth: (NSError*) error
{
    if (error == NULL) {
        NSLog(@"Game Center Auth success!");
    }
    else {
        NSLog(@"Game Center Auth faild!");
    }
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error
{
    if (error == NULL) {
        NSLog(@"Game Center reload scores success!");
    }
    else {
        NSLog(@"Game Center reload scores failed!");
    }
}
@end
