//
//  OptionLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/15/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "OptionLayer.h"
#import "GameLayer.h"
#import "MenuLayer.h"
#import "ShareLayer.h"
#import "Global.h"


@implementation OptionLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	OptionLayer *layer = [OptionLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
		
        [self createBackground];
        [self createMenu];
	}
	return self;
}
-(void)createBackground
{    
    newSprite(@"m_bg", G_SWIDTH/2, G_SHEIGHT/2, self, 0, RATIO_XY);
    newSprite(@"logo", G_SWIDTH/2, getY(105), self, 0, RATIO_XY);
    newSprite(@"music", G_SWIDTH/2, getY(325), self, 0, RATIO_XY);
    newSprite(@"effect", G_SWIDTH/2, getY(567), self, 0, RATIO_XY);
}

-(void) createMenu
{
    
    CCMenuItemToggle* iMusic = newToggleButton(@"sound", G_SWIDTH/2, getY(440), self, @selector(onMusic), YES, RATIO_XY);
    
    CCMenuItemToggle* iSound = newToggleButton(@"sound", G_SWIDTH/2, getY(675), self, @selector(onEffect), YES, RATIO_XY);
    
    
    
    CCMenuItemImage* iPlay = newButton(@"btn_play", G_SWIDTH/2, getY(820), self, @selector(onPlay), YES, RATIO_XY);
    
    CCMenuItemImage* iShare = newButton(@"btn_share", G_SWIDTH/2, getY(920), self, @selector(onShare), YES, RATIO_XY);
    
    CCMenuItemImage* iBack = newButton(@"btn_back", 0, getY(1000), self, @selector(onBack), YES, RATIO_XY);
    iBack.anchorPoint = ccp(0.f, 0.5f);
    
    CCMenu *menu = [CCMenu menuWithItems:iMusic, iSound, iShare, iPlay, iBack, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:0];
    
}

-(void)onMusic
{
    
}

-(void)onEffect
{
    
}

-(void)onShare
{
    g_bFromMenu = NO;
    [[CCDirector sharedDirector] replaceScene:[ShareLayer node]];
}

-(void)onPlay
{
//    [[CCDirector sharedDirector] replaceScene:[GameLayer node]];
    playButtonAction();
}

-(void)onBack
{
    [[CCDirector sharedDirector] replaceScene:[MenuLayer node]];
}

@end
