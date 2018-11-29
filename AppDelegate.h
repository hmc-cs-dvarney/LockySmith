//
//  AppDelegate.h
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright Dalton 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "GADInterstitial.h"
#import "GADBannerView.h"

#import "GameCenterManager.h"
#import <GameKit/GameKit.h>


// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate,GADInterstitialDelegate, GADBannerViewDelegate,GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref

    GADInterstitial *admobInterstitial;
    GADBannerView *m_admobBanner;

}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

#pragma mark Game Center
- (void) submitScore:(int) uploadScore;
- (void) showLeaderboard;
- (void) showAchievements;
- (BOOL) initGameCenter;

-(void ) showInterstitial;
-(void ) admobBanner;


@end
