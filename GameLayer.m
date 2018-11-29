//
//  GameLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/15/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "GameLayer.h"
#import "EndLayer.h"
#import "Global.h"


@implementation GameLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
		self.touchEnabled = YES;
        [self initVar];
        [self createBackground];
        [self createMenu];
        
	}
	return self;
}
-(void)initVar
{
    g_bScorable = YES;
    g_nScore = 0;
    m_fDistance = 400;
    m_aryBlock = [[NSMutableArray alloc] init];
}

-(void)createBackground
{
    
    
    bg1 = [CCSprite spriteWithFile:@"bg.png"];
    bg1.anchorPoint = ccp(0.5f, 0.f);
    bg1.position = ccp(G_SWIDTH/2, 0);
    [self addChild:bg1];
    
    bg2 = [CCSprite spriteWithFile:@"bg.png"];
    bg2.anchorPoint = ccp(0.5f, 0.f);
    bg2.position = ccp(G_SWIDTH/2,[bg1 boundingBox].size.height-G_SHEIGHT*2);
    [self addChild:bg2];

   // newSprite(@"bg", G_SWIDTH/2, G_SHEIGHT/2, self, 0, RATIO_XY);
    m_spHero = newSprite(@"char1", G_SWIDTH/2, getY(1000), self, 2, RATIO_XY);
    m_spHero.anchorPoint = ccp(0.5f, 0.f);
    m_spTmp = newSprite(@"char1", G_SWIDTH/2, getY(1000), self, 2, RATIO_XY);
    m_spTmp.scaleX = 0.2f;
    m_spTmp.anchorPoint = ccp(0.5f, 0.f);
    m_spTmp.opacity = 0;
    
    [m_spHero runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:g_frmHero]]];
    
    m_lbScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", g_nScore] fontName:@"Avenir-Black" fontSize:50*G_SCALEX/g_fScaleR];
    m_lbScore.position = ccp(getX(620), getY(50));
    m_lbScore.anchorPoint = ccp(1.f, 0.5f);
    [self addChild:m_lbScore z:10];
    
    [self schedule:@selector(onTimer:) interval:0.01];
    
    
}

-(void) createMenu
{
    
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    m_ptStart = location;
    m_bTouched = YES;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    m_bTouched = NO;
}


-(void) onTimer:(ccTime)dt
{
    bg1.position = ccp(bg1.position.x, bg1.position.y-(8*G_SCALEY/g_fScaleR));
    bg2.position = ccp(bg2.position.x, bg2.position.y-(8*G_SCALEY/g_fScaleR));
    if (bg1.position.y < -[bg1 boundingBox ].size.height){
        bg1.position = ccp(bg1.position.x,bg2.position.y+[bg2 boundingBox].size.height);
        
    }
    if (bg2.position.y < -[bg2 boundingBox ].size.height){
        bg2.position = ccp(bg1.position.x,bg1.position.y+[bg1 boundingBox].size.height);
        
    }
    
    
    BOOL bPassing = NO;
    m_nCnt++;

    for (int i = [m_aryBlock count] -1; i >= 0; i--) {
        CCSprite *wall = [m_aryBlock objectAtIndex:i];
        if (wall.position.y < -100) {
            g_bScorable = YES;
            [m_aryBlock removeObject:wall];
            [self removeChild:wall cleanup:YES];
            continue;
        }
        wall.position = ccpAdd(wall.position, ccp(0, -8*G_SCALEY/g_fScaleR));
        if (CGRectIntersectsRect(m_spTmp.boundingBox, wall.boundingBox))
        {
            if(wall.tag == TMP_TAG || wall.tag == DOOR_TAG)
            {
                if(g_bScorable) {
                    g_nScore++;
                    g_bScorable = NO;
                }
                if (wall.tag == DOOR_TAG) {
                    wall.tag = 0;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
                    wall.anchorPoint = ccp(1.f, 0.f);
                    [wall runAction:[CCRotateBy actionWithDuration:0.2f angle:90.f]];
                }
                bPassing = YES;
            }
            else if(wall.tag == WALL_TAG)
            {
                [self gameOver];
            }

        }
        if(i == 0)
        m_fDistance+=8*G_SCALEY/g_fScaleR;
   }
    
    if(m_bTouched)
    {
        if(bPassing) return;

        if (m_ptStart.x<G_SWIDTH/2 && m_spHero.position.x>0) {
            m_spHero.position = ccpAdd(m_spHero.position, ccp(-20*G_SCALEX/g_fScaleR, 0));
            m_spTmp.position = ccpAdd(m_spTmp.position, ccp(-20*G_SCALEX/g_fScaleR, 0));
        }
        else if(m_ptStart.x>G_SWIDTH/2 && m_spHero.position.x<getX(640))
        {
            m_spHero.position = ccpAdd(m_spHero.position, ccp(20*G_SCALEX/g_fScaleR, 0));
            m_spTmp.position = ccpAdd(m_spTmp.position, ccp(20*G_SCALEX/g_fScaleR, 0));
        }
        
    }
    
    if(m_fDistance >= 200)
    {
        m_fDistance = 0;
        m_nCnt = 0;
        float pXDoor = arc4random() % 540 + 50;
        
        CCSprite *door = newSprite(@"door", getX(pXDoor + 119/2), getY(-100), self, 1, RATIO_XY);
        door.anchorPoint = ccp(1.f, 0.f);
        [m_aryBlock addObject:door];
        door.tag = DOOR_TAG;
        
        
        CCSprite *tmpDoor = newSprite(@"door", getX(pXDoor), getY(-100), self, 1, RATIO_XY);
        tmpDoor.anchorPoint = ccp(0.5f, 0.0f);
        tmpDoor.scaleX = 0.2f;
        [m_aryBlock addObject:tmpDoor];
        tmpDoor.opacity = 0;
        tmpDoor.tag = TMP_TAG;
        
        CCSprite *wall1 = newSprite(@"wall", getX(pXDoor - 119/2), getY(-100), self, 1, RATIO_XY);
        wall1.anchorPoint = ccp(1.f, 0.f);
        [m_aryBlock addObject:wall1];
        wall1.tag = WALL_TAG;
        
        CCSprite *wall2 = newSprite(@"wall", getX(pXDoor + 119/2), getY(-100), self, 1, RATIO_XY);
        wall2.anchorPoint = ccp(0.f, 0.f);
        [m_aryBlock addObject:wall2];
        wall2.tag = WALL_TAG;
        
    }
    
    [m_lbScore setString:[NSString stringWithFormat:@"%d", g_nScore]];
    
}
-(void) gameOver
{
    [m_spHero stopAllActions];
    [self unschedule:@selector(onTimer:)];
    [[CCDirector sharedDirector] replaceScene:[EndLayer node]];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
