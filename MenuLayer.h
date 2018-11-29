//
//  MenuLayer.h
//  Lock Smith
//
//  Created by Dalton on 12/14/14.
//  Copyright 2014 Dalton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuLayer : CCLayer {
    
    CCMenuItemImage *m_iPlay;
    CCMenuItemImage *m_iOption;
    CCMenuItemImage *m_iShare;
}
+(CCScene *) scene;
@end
