//
//  EndLayer.h
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EndLayer : CCLayer {
    CCLabelTTF *m_lbScore;
    CCLabelTTF *m_lbHighScore;
    
}
+(CCScene *) scene;
@end
