//
//  Clouds.m
//  TrainCat
//
//  Created by Alankar Misra on 13/04/13.
//
//

#import "CloudsLayer.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CocosConstants.h"

@interface CloudsLayer()
@property (nonatomic, strong) NSMutableArray *clouds;
@property (nonatomic, assign) BOOL randomX;
@end

@implementation CloudsLayer

-(id)init {
    self = [super init];
    if(self) {
        self.clouds = [[NSMutableArray alloc] init];
        self.randomX = YES;
        for(NSUInteger i=0; i<5; ++i) {
            [self addClouds];
        }
        self.randomX = NO;
        [self schedule:@selector(gameLogic:) interval:3.0];
        [self setIsTouchEnabled:YES];
    }
    return self;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	CloudsLayer *layer = [CloudsLayer node];
	[scene addChild: layer];
	return scene;
}

-(void)resumeAnimation {
    [self resumeSchedulerAndActions];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:kMenuBackgroundMusic];
    [self setIsTouchEnabled:YES];
}

-(void)gameLogic:(ccTime)dt {
    [self addClouds];
}

-(void)addClouds {
    CCSprite *cloud = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"cloud%d.png", arc4random()%5+1]];
    
    // Determine where to spawn the cloud along the Y axis
    CGSize winSize = getWinSize();
    
    int maxY = winSize.height - cloud.contentSize.height/2;
    int minY = maxY - 200;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    int actualX;
    if(self.randomX) {
        int minX = cloud.contentSize.width;
        int maxX = winSize.width - cloud.contentSize.width;
        int rangeX = maxX - minX;
        actualX = (arc4random() % rangeX) + minX;
    } else {
        actualX = winSize.width + cloud.contentSize.width/2;
    }
    
    // Create the cloud slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    cloud.position = ccp(actualX, actualY);
    cloud.tag = 1;
    [[self clouds] addObject:cloud];
    [self addChild:cloud];
    
    // Determine the speed of the cloud
    int minDuration = 30.0;
    int maxDuration = 40.0;

    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-cloud.contentSize.width/2, actualY)];
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [[self clouds] removeObject:node];
        [node removeFromParentAndCleanup:YES];
    }];
    [cloud runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    NSMutableArray *cloudsToDelete = [[NSMutableArray alloc] init];
    for(CCSprite *cloud in [self clouds]) {
        if(CGRectContainsPoint(cloud.boundingBox, location)) {
            [cloudsToDelete addObject:cloud];
        }
    }
    
    for(CCSprite *cloud in cloudsToDelete) {
        CCSprite *cloudBurst = [CCSprite spriteWithSpriteFrameName:@"cloudBurst.png"];
        cloudBurst.position = cloud.position;
        [[self clouds] removeObject:cloud];
        [self removeChild:cloud cleanup:YES];
        [[SimpleAudioEngine sharedEngine] playEffect:kPopEffect];
        [self addChild:cloudBurst];
        [cloudBurst runAction:[CCSequence actions:
                          [CCDelayTime actionWithDuration:0.05],
                          [CCCallBlockN actionWithBlock:^(CCNode *node) {
                            [node removeFromParentAndCleanup:YES];
                          }]
                        , nil]];
    }
    
}

-(void)pauseAnimation {
    [self setIsTouchEnabled:NO];
    [self pauseSchedulerAndActions];
}


@end
