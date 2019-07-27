//
//  MCTS.h
//  MonteCarloKit
//
//  Created by Philipp Schunker on 04.11.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCTreeNode.h"
#import "MCStateDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTS : NSObject

@property (nonatomic,strong) MCTreeNode *startNode;

@property (nonatomic,assign) NSUInteger simDepth;
@property (nonatomic,assign) NSUInteger simCount;
@property (nonatomic,assign) NSUInteger maxSimCount;

@property (nonatomic,assign) double exploitationCoefficient;
@property (nonatomic,assign) double explorationCoefficient;

@property (nonatomic,assign) BOOL *pStopFlag;
@property (nonatomic,weak) id<MCStateDelegate> stateDelegate;

@property (nonatomic,assign) BOOL debug;

-(instancetype)init:(MCTreeNode *)startNode simulationCount:(NSUInteger)maxSimCount;

//-(double)uct:(double)numerator denominator:(double)denominator;
-(double)uct:(double)numerator denominator:(double)denominator parentDenominator:(double)pd;
-(NSMutableArray<MCTreeNode *>*)expand:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth prevNodes:(NSArray *)prevNodes;
-(MCTreeNode *)selection:(MCTreeNode *)node prevNodes:(NSMutableArray *)pnodes;
-(MCTreeNode *)simulation:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth lastNodes:(NSArray *)lastNodes;
-(void)main;
-(void)setStopFlagPointer:(BOOL *)val;


@end

NS_ASSUME_NONNULL_END
