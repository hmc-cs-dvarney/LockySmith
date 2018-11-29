//
//  TutoLayer.m
//  Lock Smith
//
//  Created by Dalton on 12/18/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import "TutoLayer.h"
#import "GameLayer.h"
#import "Global.h"

@implementation TutoLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	TutoLayer *layer = [TutoLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        [self setTouchEnabled:YES];
        [self createBackground];
	}
	return self;
}

-(void)createBackground
{
    newSprite(@"tuto_bg", G_SWIDTH/2, G_SHEIGHT/2, self, 0, RATIO_XY);
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[GameLayer node]];
}

@end
