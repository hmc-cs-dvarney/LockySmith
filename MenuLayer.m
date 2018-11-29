//
//  MenuLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "MenuLayer.h"
#import "ShareLayer.h"
#import "OptionLayer.h"
#import "GameLayer.h"
#import "Global.h"


@implementation MenuLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MenuLayer *layer = [MenuLayer node];
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
    m_iPlay = newButton(@"btn_play", G_SWIDTH/2, getY(440), self, @selector(onPlay), YES, RATIO_Y);
    //m_iOption = newButton(@"btn_option", G_SWIDTH/2, getY(524), self, @selector(onOption), YES, RATIO_Y);
    m_iShare = newButton(@"btn_share", G_SWIDTH/2, getY(660), self, @selector(onShare), YES, RATIO_Y);
    
    CCMenu *menu = [CCMenu menuWithItems:m_iPlay, m_iShare, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:0];
}

-(void)onPlay
{
//    [[CCDirector sharedDirector] replaceScene:[GameLayer node]];
    playButtonAction();
}

-(void)onOption
{
    [[CCDirector sharedDirector] replaceScene:[OptionLayer node]];
}

-(void)onShare
{
    [[CCDirector sharedDirector] replaceScene:[ShareLayer node]];
}

@end
