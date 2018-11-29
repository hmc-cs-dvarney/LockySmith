//
//  EndLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "EndLayer.h"
#import "MenuLayer.h"
#import "OptionLayer.h"
#import "Global.h"

#import "AppDelegate.h"


@implementation EndLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	EndLayer *layer = [EndLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
		
        [self createBackground];
        [self createMenu];
        [[SimpleAudioEngine sharedEngine] playEffect:@"over.mp3"];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:(0.25)];
	}
	return self;
}
-(void)createBackground
{
    newSprite(@"m_bg", G_SWIDTH/2, G_SHEIGHT/2, self, 0, RATIO_XY);
    newSprite(@"logo", G_SWIDTH/2, getY(105), self, 0, RATIO_XY);
    
    CCSprite *spScore = newSprite(@"score", G_SWIDTH/2, getY(230), self, 0, RATIO_XY);
    spScore.scale = G_SCALEY *0.6f;
    spScore.anchorPoint = ccp(1.f, 0.5f);
    
    CCSprite *spHScore = newSprite(@"highscore", G_SWIDTH/2, getY(290), self, 0, RATIO_XY);
    spHScore.anchorPoint = ccp(1.f, 0.5f);
    spHScore.scale = G_SCALEY *0.6f;
    
    
    m_lbScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", g_nScore] fontName:@"Avenir-Black" fontSize:50*G_SCALEX/g_fScaleR];
    m_lbScore.position = ccp(G_SWIDTH/2 + getX(50), getY(230));
    m_lbScore.anchorPoint = ccp(0.f, 0.5f);
    [self addChild:m_lbScore z:10];
    
    int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high"];
    
    if(g_nScore > highScore)
    {
        highScore = g_nScore;
        [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"high"];
        AppController *app = (AppController*)[UIApplication sharedApplication].delegate;
        [app submitScore:g_nScore];
    }
    
    m_lbHighScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", highScore] fontName:@"Avenir-Black" fontSize:50*G_SCALEX/g_fScaleR];
    m_lbHighScore.position = ccp(G_SWIDTH/2 + getX(50), getY(290));
    m_lbHighScore.anchorPoint = ccp(0.f, 0.5f);
    [self addChild:m_lbHighScore z:10];
    
    
    
    

    AppController *app = (AppController*)[UIApplication sharedApplication].delegate;
    [app showInterstitial];
}

-(void) createMenu
{
    CCMenuItemImage* iRetry = newButton(@"btn_replay", G_SWIDTH/2, getY(880), self, @selector(onPlay), YES, RATIO_Y);
    CCMenuItemImage* iFaceBook = newButton(@"btn_fb", G_SWIDTH/2, getY(420), self, @selector(onFB), YES, RATIO_Y);
    CCMenuItemImage* iTwitter = newButton(@"btn_tw", G_SWIDTH/2, getY(570), self, @selector(onTW), YES, RATIO_Y);
    //CCMenuItemImage* iOption = newButton(@"btn_option", G_SWIDTH/2, getY(940), self, @selector(onOption), YES, RATIO_Y);
    
   


    CCMenu *menu = [CCMenu menuWithItems:iFaceBook, iTwitter, iRetry, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:0];
}
-(void) onOption
{
    [[CCDirector sharedDirector] replaceScene:[OptionLayer node]];
}

-(void)onFB
{
    fbButtonAction(g_nScore);
}

-(void)onTW
{
    twButtonAction(g_nScore);
}

-(void)onPlay
{
    //    [[CCDirector sharedDirector] replaceScene:[GameLayer node]];
    playButtonAction();
}

-(void)onBack
{
    
}

@end
