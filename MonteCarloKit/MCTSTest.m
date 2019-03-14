//
//  MonteCarloTreeSearchTest.m
//  MCTSNav
//
//  Created by Philipp Schunker on 11.01.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import "MCTSTest.h"

@interface MCTSTest ()

@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, assign) BOOL stopFlag;

@end

@implementation MCTSTest


- (instancetype)init:(MCTreeNode *)startNode end:(MCTreeNode *)endNode simulationCount:(NSUInteger)maxSimCount{
    self = [super init];
    if(self){
        _startNode=startNode;
        _endNode=endNode;
        _maxSimCount=maxSimCount;
    }
    
    self.startLocation = [[CLLocation alloc] initWithLatitude:startNode.latitude longitude:startNode.longitude];
    self.endLocation = [[CLLocation alloc] initWithLatitude:endNode.latitude longitude:endNode.longitude];
    
    self.maxSimCount = maxSimCount;
    self.explorationCoefficient = 2;
    self.stopFlag = NO;
    self.pStopFlag = &_stopFlag;
    
    return self;
}

-(MCTreeNode *)selection:(MCTreeNode *)node prevNodes:(NSMutableArray*)pnodes level:(NSUInteger)level{
    MCTreeNode *nextNode = node;
    MCTreeNode *parentNode = node;
    //NSLog(@"selection %@",nextNode.nid);
    [pnodes addObject:nextNode];    //important
    
    //----
    //PSTreeManager *treeManager = [[PSTreeManager alloc] init];
    //NSArray<PSTreeNode *> *nextNodes = [treeManager getChildNodesForNode:nextNode level:0];
    NSArray<MCTreeNode *> *nextNodes = [self.stateDelegate getStateUpdatesForNode:nextNode level:0];
    
    if([nextNode.nodes count] < [nextNodes count]){
        for(MCTreeNode *inode in nextNodes){
            BOOL expand = YES;
                for(MCTreeNode *cnode in nextNode.nodes){
                    if([cnode isEqual:inode]){
                        expand = NO;
                    }
                }
     
            if(expand){
                NSLog(@"expand %@",inode.nid);
                [nextNode addNode:inode];
                //[nextNode.nodes addObject:inode];
                [pnodes addObject:inode];
             
                return inode;
            }
        }
    }
    //----
    
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
        
        //----
        //PSTreeManager *treeManager = [[PSTreeManager alloc] init];
        //NSArray<PSTreeNode *> *nextNodes = [treeManager getChildNodesForNode:nextNode level:0];
        NSArray<MCTreeNode *> *nextNodes = [self.stateDelegate getStateUpdatesForNode:nextNode level:0];
        if([nextNode.nodes count] < [nextNodes count]){
            //NSLog(@"nextNode.nodes: %ld",[nextNode.nodes count]);
            //NSLog(@"nextNodes: %ld",[nextNodes count]);
            for(MCTreeNode *inode in nextNodes){
                BOOL expand = YES;
                for(MCTreeNode *cnode in nextNode.nodes){
                    if([cnode isEqual:inode]){
                        expand = NO;
                    }
                }
                
                if(expand){
                    NSLog(@"expand %@ %ld",inode.nid,i);
                    [nextNode addNode:inode];
                    //[nextNode.nodes addObject:inode];
                    [pnodes addObject:inode];
                 
                    return inode;
                }
            }
        }
        //----
        
        [pnodes addObject:nextNode];    //important
        i++;
    }
    
    NSLog(@"selection end %@ %ld",nextNode.nid,i);
    return nextNode;
}

-(double)uct:(double)numerator denominator:(double)denominator parentDenominator:(double)pd{
    double exploitation = numerator;
    double exploration = 0;
    
    if(denominator!=0){
        exploitation = exploitation/denominator;
        //exploration = sqrt(2.0f) * sqrt((log(self.simCount)/denominator));
    }
    //exploitation = exploitation/denominator;
    //exploration = sqrt(2.0f) * sqrt((log(self.simCount)/denominator));
    exploration = sqrt(2.0f) * sqrt((log(pd)/denominator));
    //exploration = self.explorationCoefficient * sqrt((log(pd)/denominator));
    //NSLog(@"exploitaton %g",exploitation);
    //NSLog(@"exploration %g",exploration);
    
    double result = exploitation+exploration;
    return result;
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
        node = [self expand:node maxdepth:0 depth:0 lastNodes:lastNodes];
        if([node.nodes count] == 0){
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

-(void)main{
    //PSTreeNode *currentNode = self.startNode;
    //expand root node first
    
    double initVal = [self.startLocation distanceFromLocation:self.endLocation];
    double bestVal = initVal;
    double bestVal2 = 1/0.0;     //new
    NSLog(@"initial distance: %g m",initVal);
    
    self.simCount = 0;
    while(self.simCount<self.maxSimCount && !(*self.pStopFlag)){
        //NSLog(@"start %ld",self.simCount);
        NSMutableArray *pnodes = [[NSMutableArray alloc] init];
        //PSTreeNode *currentNode = [self selectionRec:self.startNode prevNodes:pnodes level:0];
        MCTreeNode *currentNode = [self selection:self.startNode prevNodes:pnodes level:0];
        
        //-----
        /*
        if(currentNode.denominator != 0){
            //if(currentNode.denominator != 0 || [currentNode isEqual:self.startNode]){
            [self expansion:currentNode prevNodes:pnodes];
            //NSLog(@"currentNode.nodes %ld",[currentNode.nodes count]);
            if([currentNode.nodes count]>0){
                currentNode=currentNode.nodes[0];
            }
        }
        */
        //-----
        
        MCTreeNode *copyNode = [[MCTreeNode alloc] init];
        copyNode.nid = [NSString stringWithString:currentNode.nid];
        copyNode.latitude = currentNode.latitude;
        copyNode.longitude = currentNode.longitude;
        
        //PSTreeNode *destinationNode = [self simulation:copyNode maxdepth:3 depth:0 lastNodes:[NSMutableArray array]];
        MCTreeNode *destinationNode = [self simulation:copyNode maxdepth:3];
        
        //TODO: wrap in evaluation function
        CLLocation *location = [[CLLocation alloc] initWithLatitude:destinationNode.latitude longitude:destinationNode.longitude];
        double distance = [location distanceFromLocation:self.endLocation];
        double distanceStart = [location distanceFromLocation:self.startLocation];  //new
        double distanceHeuristic = distance + distanceStart;    //new
        double numerator = 0;
        //currentNode.numerator = currentNode.numerator + distance;
        
        if(distance<initVal){
            //NSLog(@"distance: %g",distance);
            numerator++;
            //numerator=numerator+10;
            //numerator=numerator+self.simCount;
            if(distance<bestVal){
                //numerator++;
                //numerator=numerator+20;
                numerator=numerator+self.simCount;
                bestVal=distance;
                
                if(distanceHeuristic<bestVal2){
                    numerator++;
                    //numerator=numerator+20;
                    //numerator=numerator+self.simCount;
                    bestVal2=distanceHeuristic;
                }
                
            }
        }
        
        //backpropagation
        for(MCTreeNode *prevNode in pnodes){
            //NSLog(@"backpropagation");
            //prevNode.numerator = prevNode.numerator/currentNode.numerator;     //higher is better
            prevNode.numerator=prevNode.numerator+numerator;
            prevNode.denominator++;
        }
        
        self.simCount++;
    }
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
        
        [node addNode:cnode];
        //ix++;
    }
    
    return node;
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
