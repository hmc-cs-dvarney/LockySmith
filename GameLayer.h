//
//  GameLayer.h
//  Lock Smith
//
//  Created by Dalton on 12/15/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define DOOR_TAG    100
#define TMP_TAG    101
#define WALL_TAG    102

@interface CCParallaxNode (Extras)

-(void) incrementOffset:(CGPoint)offset forChild:(CCNode*)node;

@end
@interface GameLayer : CCLayer {
    CCSprite *m_spHero, *m_spTmp;
    NSMutableArray *m_aryBlock;
    int m_nCnt;
    float  m_fDistance;
    CGPoint m_ptStart;
    BOOL m_bTouched;
    CCLabelTTF *m_lbScore;
    BOOL g_bScorable;
    CCParallaxNode *_backgroundNode;
    CCSprite *bg1;
    CCSprite *bg2;
    
}
+(CCScene *) scene;
@end
