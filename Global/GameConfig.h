//
//  GameConfig.h
//  shootingbird
//
//  Created by Rijing on 10/15/14.
//  Copyright 2014 Rijing. All rights reserved.
//

#ifndef _GAME_CONFIG_H
#define _GAME_CONFIG_H
#import "cocos2d.h"
#import "Constants.h"

#define TEXT_TAG    1
#define FX_BTN() [[SimpleAudioEngine sharedEngine] playEffect:@"button.mp3"];

extern BOOL g_bMusicMute;
extern BOOL g_bSoundMute;
extern int g_nScore;

extern BOOL g_bFromMenu;

extern CCAnimation *g_frmHero;





#endif