//
//  MonteCarloTreeSearchTest.h
//  MCTSNav
//
//  Created by Philipp Schunker on 11.01.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MCTreeNode.h"
#import "MCStateDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTSTest : NSObject


//-(instancetype)init:(PSTreeNode *)startNode end:(PSTreeNode *)endNode;
-(instancetype)init:(MCTreeNode *)startNode end:(MCTreeNode *)endNode simulationCount:(NSUInteger)maxSimCount;

-(MCTreeNode *)selection:(MCTreeNode *)node prevNodes:(NSMutableArray *)pnodes level:(NSUInteger)level;
//-(NSMutableArray<PSTreeNode *>*)expansion:(PSTreeNode *)node;
-(NSMutableArray<MCTreeNode *>*)expansion:(MCTreeNode *)node prevNodes:(NSMutableArray *)pnodes;
-(MCTreeNode *)simulation:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth lastNodes:(NSArray *)lastNodes;

//-(PSTreeNode *)main:(PSTreeNode *)rootnode;
-(void)main;
//-(double)uct:(double)numerator denominator:(double)denominator;
-(double)uct:(double)numerator denominator:(double)denominator parentDenominator:(double)pd;
-(MCTreeNode *)expand:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth lastNodes:(NSArray *)lastNodes;
-(void)setStopFlagPointer:(BOOL *)val;

@property (nonatomic,strong) MCTreeNode *startNode;
@property (nonatomic,strong) MCTreeNode *endNode;
@property (nonatomic,assign) NSUInteger simCount;
@property (nonatomic,assign) NSUInteger maxSimCount;
@property (nonatomic,assign) double explorationCoefficient;
@property (nonatomic,assign) BOOL *pStopFlag;
@property (nonatomic,strong) id<MCStateDelegate> stateDelegate;

@end

NS_ASSUME_NONNULL_END
