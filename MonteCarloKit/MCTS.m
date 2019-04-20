//
//  MCTS.m
//  MCTSNav
//
//  Created by Philipp Schunker on 04.11.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import "MCTS.h"

@interface MCTS ()

//@property (nonatomic, strong) MCState *startState;
//@property (nonatomic, strong) MCState *endState;
@property (nonatomic, assign) BOOL stopFlag;

@end

@implementation MCTS

/*
- (instancetype)init{
    self = [super init];
    return self;
}*/

- (instancetype)init:(MCTreeNode *)startNode simulationCount:(NSUInteger)maxSimCount{
    self = [super init];
    if(self){
        self.startNode = startNode;
        self.simDepth = INFINITY;
        self.maxSimCount = maxSimCount;
        
        self.explorationCoefficient = 2;
        self.exploitationCoefficient = 1;
        
        self.stopFlag = NO;
        self.pStopFlag = &_stopFlag;
    }
    
    return self;
}

-(MCTreeNode *)expand:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth lastNodes:(NSArray *)lastNodes{
    //NSLog(@"expand %@ level: %ld",node.nid,depth);
    
    NSMutableArray *visitedNodes = [lastNodes mutableCopy];
    
    //PSTreeManager *treeManager = [[PSTreeManager alloc] init];
    //NSArray<PSTreeNode *> *childNodes = [treeManager getChildNodesForNode:node level:0];
    NSArray<MCTreeNode *> *childNodes = [self.stateDelegate getStateUpdatesForNode:node level:0];
    //NSUInteger ix = 0;
    //for(PSTreeNode *node in childNodes){
    for(NSUInteger ix=0;ix<[childNodes count];ix++){
        MCTreeNode *cnode = childNodes[ix];
        //NSLog(@"%ld %@",ix,cnode.nid);
        
        //prevent node recursion in recursive [expand:] calls
        if([lastNodes containsObject:cnode]){
            //NSLog(@"containsobject");
            continue;
        }
        /*
        if([[treeManager getChildNodesForNode:cnode level:0] count] == 1){
            continue;
        }*/
        
        /*
        BOOL c = NO;
        for(PSTreeNode *n in lastNodes){
            if([n.nid isEqualToString:cnode.nid]){
                NSLog(@"%@",n);
                NSLog(@"%@",cnode);
                c = YES;
            }
        }
         
        if(c){
            //NSLog(@"containsobject");
            continue;
        }
        */
        
        if((depth+1)<maxdepth){
            [visitedNodes addObject:cnode];
            //NSArray *nextVisitedNodes = [visitedNodes arrayByAddingObject:destinationNode];
            NSArray *nextVisitedNodes = [visitedNodes copy];
            
            cnode = [self expand:cnode maxdepth:maxdepth depth:(depth+1) lastNodes:nextVisitedNodes];
        }
        
        cnode.parentNode = node;
        [node addNode:cnode];
        //ix++;
    }
    
    return node;
}

-(double)uct:(double)numerator denominator:(double)denominator parentDenominator:(double)pd{
    double exploitation = numerator;
    double exploration = 0;
    
    if(denominator==0){
        return DBL_MAX;
    }
    /*
    if(denominator!=0){
     exploitation = exploitation/denominator;
     //exploration = sqrt(2.0f) * sqrt((log(self.simCount)/denominator));
    }
    */
    exploitation = exploitation/denominator * self.exploitationCoefficient;
    //exploration = sqrt(2.0f) * sqrt((log(self.simCount)/denominator));
    //exploration = sqrt(2.0f) * sqrt((log(pd)/denominator));
    exploration = self.explorationCoefficient * sqrt((log(pd)/denominator));
    //NSLog(@"exploitaton %g",exploitation);
    //NSLog(@"exploration %g",exploration);
    
    double result = exploitation+exploration;
    return result;
}

#pragma mark - MCTS steps

-(MCTreeNode *)selection:(MCTreeNode *)node prevNodes:(NSMutableArray*)pnodes{
    MCTreeNode *nextNode = node;
    MCTreeNode *parentNode = node;
    //NSLog(@"selection %@",nextNode.nid);
    [pnodes addObject:nextNode];    //important
    
    NSUInteger i = 0;
    while([nextNode.nodes count]>0){
        //NSLog(@"nextNode %@ %ld",nextNode.nid,i);
        
        NSArray<MCTreeNode *> *childNodes = nextNode.nodes;
        parentNode = nextNode;
        nextNode = childNodes[0];
        //NSLog(@"parentNode: %@",parentNode);
        //NSLog(@"nextNode: %@",nextNode);
        
        /*
        NSUInteger jx = 1;
        while([pnodes containsObject:nextNode] && jx < [childNodes count]){
            nextNode = childNodes[jx];
            jx++;
        }
        
        if([pnodes containsObject:nextNode]){
            return node;
        }*/
        
        for(MCTreeNode *cnode in childNodes){
            //NSLog(@"cnode %@",cnode.nid);
            
            /*
            if(cnode.denominator>nextNode.denominator && ![pnodes containsObject:cnode]){
                NSLog(@"set new node");
                nextNode=cnode;
            }*/
            
            double uctNode = [self uct:cnode.numerator denominator:cnode.denominator parentDenominator:parentNode.denominator];
            double uctNextNode = [self uct:nextNode.numerator denominator:nextNode.denominator parentDenominator:parentNode.denominator];
            
            //NSLog(@"uctNode %g",uctNode);
            //NSLog(@"uctNextNode %g",uctNextNode);
            
            //if(uctNode > uctNextNode && ![pnodes containsObject:cnode]){
            if(uctNode > uctNextNode){
                //NSLog(@"%g > %g",uctNode,uctNextNode);
                nextNode = cnode;
            }
            
        }
        [pnodes addObject:nextNode];    //important
        i++;
    }
    
    NSLog(@"selection end %@ %ld",nextNode.nid,i);
    return nextNode;
}

-(NSMutableArray<MCTreeNode *>*)expansion:(MCTreeNode *)node prevNodes:(NSMutableArray *)pnodes{
    MCTreeNode *expNode = [self expand:node maxdepth:0 depth:0 lastNodes:pnodes];
    //[node.nodes addObjectsFromArray:expNode.nodes];
    //PSTreeNode *newNode = [[PSTreeNode alloc] init];
    /*
    if([node.nodes count] >0){
        //return node.nodes;
        return
    }
    */
    
    if ([expNode.nodes count] == 0) {
        return nil;
    }
    
    return expNode.nodes;
}

-(MCTreeNode *)simulation:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth{
    //important: simulate a playout only with a copy node
    NSMutableArray *lastNodes = [[NSMutableArray alloc] init];
    [lastNodes addObject:node];
    
    NSUInteger depth = 0;
    while(depth < maxdepth){
        NSUInteger oldNodeCount = [node.nodes count];
        node = [self expand:node maxdepth:0 depth:0 lastNodes:lastNodes];
        NSUInteger newNodeCount = [node.nodes count];
        
        if((newNodeCount == 0) || (newNodeCount == oldNodeCount)){
            return node;
        }
        
        NSMutableArray<MCTreeNode *>* childNodes = node.nodes;
        MCTreeNode *nextNode = childNodes[arc4random_uniform([childNodes count])];
        node = nextNode;
        
        [lastNodes addObject:node];
        
        depth++;
    }
    
    return node;
}


-(double)evaluate:(MCTreeNode *)currentNode toNode:(MCTreeNode *)destinationNode withInitValue:(double)initVal AndBestValue:(double *)bestVal{
    /*
    CLLocation *location = [[CLLocation alloc] initWithLatitude:destinationNode.latitude longitude:destinationNode.longitude];
    double distance = [location distanceFromLocation:self.endLocation];
    */
    
    double value = [currentNode compareToState:destinationNode];
    
    //double distanceStart = [location distanceFromLocation:self.startLocation]; //not necessary atm
    //double distanceHeuristic = distance + distanceStart;      //not working because distanceStart is increased
    //double heuristicDistance2 = distance + routeDistance;     //not working because routeDistance is increased
    double numerator = 0;
    
    if(value > initVal){
        if(value > *bestVal){
            numerator++;
            *bestVal=value;
        }
    }
    
    return numerator;
}


-(void)backpropagation:(MCTreeNode *)node numerator:(double)value{
    while(node != nil){
        node.numerator = node.numerator + value;
        node.denominator++;
        node = node.parentNode;
    }
}

-(void)main{
    //PSTreeNode *currentNode = self.startNode;
    //expand root node first
    
    //double initVal = [self.startLocation distanceFromLocation:self.endLocation];
    //double initVal = [self.startNode compareToState:self.endNode];
    //double bestVal = initVal;
    //double *pBestVal = &bestVal;

    //NSLog(@"initial value: %g m",initVal);
    
    self.simCount = 0;
    while(self.simCount<self.maxSimCount && !(*self.pStopFlag)){
        //NSLog(@"start %ld",self.simCount);
        NSMutableArray *pnodes = [[NSMutableArray alloc] init];
        //PSTreeNode *currentNode = [self selectionRec:self.startNode prevNodes:pnodes level:0];
        MCTreeNode *currentNode = [self selection:self.startNode prevNodes:pnodes];
        
        //===== expansion =====
        if(currentNode.denominator != 0){
        //if(currentNode.denominator != 0 || [currentNode isEqual:self.startNode]){
            [self expansion:currentNode prevNodes:pnodes];
            //NSLog(@"currentNode.nodes %ld",[currentNode.nodes count]);
            if([currentNode.nodes count]>0){
                //currentNode = currentNode.nodes[0];
                currentNode = currentNode.nodes[arc4random_uniform([currentNode.nodes count])];
            }
        }
        //==========
        
        //===== simulation =====
        /*
        MCTreeNode *copyNode = [[MCTreeNode alloc] init];
        copyNode.nid = [NSString stringWithString:currentNode.nid];
        copyNode.latitude = currentNode.latitude;
        copyNode.longitude = currentNode.longitude;
        */
        
        MCTreeNode *copyNode = [currentNode copy];
        
        //PSTreeNode *simNode = [self simulation:copyNode maxdepth:self.simDepth depth:0 lastNodes:[NSMutableArray array]];
        MCTreeNode *simNode = [self simulation:copyNode maxdepth:self.simDepth];
        //==========
        
        //===== evaluation =====
        //double numerator = [self evaluate:currentNode toNode:simNode withInitValue:initVal AndBestValue:pBestVal];
        double numerator = [self.stateDelegate evaluate:currentNode withNode:simNode];
        //==========
        
        //===== backpropagation =====
        /*
        for(PSTreeNode *prevNode in pnodes){
            //NSLog(@"backpropagation");
            //prevNode.numerator = prevNode.numerator/currentNode.numerator;     //higher is better
            prevNode.numerator=prevNode.numerator+numerator;
            prevNode.denominator++;
        }
        */
        [self backpropagation:currentNode numerator:numerator];
        //==========
        
        self.simCount++;
    }
}

-(void)setStopFlagPointer:(BOOL *)val{
    self.pStopFlag = val;
}

#pragma mark - recursive method versions

-(MCTreeNode *)selectionRec:(MCTreeNode *)node prevNodes:(NSMutableArray*)pnodes level:(NSUInteger)level{
    //NSLog(@"selection %@ level: %ld",node.nid,level);
    MCTreeNode *nextNode = node;
    MCTreeNode *parentNode = node;
    //NSLog(@"selection %@",nextNode.nid);
    
    if(![pnodes containsObject:nextNode]){
        [pnodes addObject:nextNode];
    }
    
    NSArray<MCTreeNode *> *childNodes = node.nodes;
    if([childNodes count]==0){
        return nextNode;
    }
    
    parentNode = nextNode;
    nextNode = childNodes[0];
    NSUInteger jx = 1;
    while([pnodes containsObject:nextNode] && jx < [childNodes count]){
        nextNode = childNodes[jx];
        jx++;
    }
    if([pnodes containsObject:nextNode]){
        return node;
    }
    
    for(MCTreeNode *cnode in childNodes){
        //&& ![pnodes containsObject:cnode]
        /*
         if(cnode.denominator>nextNode.denominator && ![pnodes containsObject:cnode]){
         NSLog(@"set new node");
         nextNode=cnode;
         }
         */
        
        double uctNode = [self uct:cnode.numerator denominator:cnode.denominator parentDenominator:parentNode.denominator];
        double uctNextNode = [self uct:nextNode.numerator denominator:nextNode.denominator parentDenominator:parentNode.denominator];
        
        if(uctNode > uctNextNode && ![pnodes containsObject:cnode]){
            NSLog(@"%g > %g",uctNode,uctNextNode);
            nextNode = cnode;
        }
        
    }
    
    //if(![pnodes containsObject:nextNode]){
    //[pnodes addObject:nextNode];
    //}
    [pnodes addObject:nextNode];
    
    if([nextNode.nodes count]){
        //go deeper
        return [self selectionRec:nextNode prevNodes:pnodes level:level+1];
    }
    //NSLog(@"selection level: %ld",level);
    //NSLog(@"selection end %@ %ld",nextNode.nid,level);
    return nextNode;
}

-(MCTreeNode *)simulation:(MCTreeNode *)node maxdepth:(NSUInteger)maxdepth depth:(NSUInteger)depth lastNodes:(NSArray *)lastNodes{
    //important: simulate a playout only with a copy node
    node = [self expand:node maxdepth:0 depth:0 lastNodes:lastNodes];
    if([node.nodes count] == 0){
        return node;
    }
    NSMutableArray<MCTreeNode *>* childNodes = node.nodes;
    MCTreeNode *nextNode = childNodes[arc4random_uniform([childNodes count])];
    //if(depth>=maxdepth){ return nextNode; };
    //return [self simulation:nextNode maxdepth:maxdepth depth:(depth+1) lastNodes:lastNodes];
    NSMutableArray *allNodes = [[NSMutableArray alloc] init];
    [allNodes addObjectsFromArray:lastNodes];
    [allNodes addObject:nextNode];
    NSArray *copyNodes = [allNodes copy];
    
    if(depth<maxdepth){
        MCTreeNode *cnode = [self simulation:nextNode maxdepth:maxdepth depth:(depth+1) lastNodes:copyNodes];
        //[node addNode:cnode];
        //return node;
        return cnode;
    }
    //[node addNode:nextNode];
    //return node;
    return nextNode;
}

@end
