//
//  ShareLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/15/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "ShareLayer.h"
#import "MenuLayer.h"
#import "OptionLayer.h"
#import "Global.h"



@implementation ShareLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ShareLayer *layer = [ShareLayer node];
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
    
    
}

-(void) createMenu
{
    CCMenuItemImage* iFaceBook = newButton(@"btn_fb", G_SWIDTH/2, getY(420), self, @selector(onFB), YES, RATIO_Y);
    CCMenuItemImage* iTwitter = newButton(@"btn_tw", G_SWIDTH/2, getY(570), self, @selector(onTW), YES, RATIO_Y);
    CCMenuItemImage* iPlay = newButton(@"btn_play", G_SWIDTH/2, getY(840), self, @selector(onPlay), YES, RATIO_Y);
    
    CCMenuItemImage* iBack = newButton(@"btn_back", 0, getY(1000), self, @selector(onBack), YES, RATIO_Y);
    iBack.anchorPoint = ccp(0.f, 0.5f);
    
    CCMenu *menu = [CCMenu menuWithItems:iFaceBook, iTwitter,iPlay, iBack, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:0];
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
    playButtonAction();
}

-(void)onBack
{
    if(g_bFromMenu)
    {
        [[CCDirector sharedDirector] replaceScene:[MenuLayer node]];
    }

    else
    {
        g_bFromMenu = YES;
        [[CCDirector sharedDirector] replaceScene:[OptionLayer node]];
    }
    
    
}
@end
