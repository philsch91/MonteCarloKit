//
//  PSMapNode.m
//  MCTSNav
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import "MCTreeNode.h"

@implementation MCTreeNode

#pragma mark - NSObject

-(instancetype)init{
    self = [super init];
    return self;
}

-(NSUInteger)hash{
    return [self.nid integerValue];
}

-(BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[MCTreeNode class]]) {
        return NO;
    }
    
    MCTreeNode *node = object;
    return [self.nid isEqualToString:node.nid];
}

#pragma mark - accessors

-(NSMutableArray<MCTreeNode *> *)nodes{
    if(!_nodes){
        _nodes = [[NSMutableArray alloc] init];
    }
    return _nodes;
}

#pragma mark - public methods

-(NSMutableArray<MCTreeNode *> *)addNode:(MCTreeNode *)node{
    [self.nodes addObject:node];
    return self.nodes;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone{
    MCTreeNode *node = [super copyWithZone:zone];
    node->_nid = [NSString stringWithString:_nid];
    node->_parentNode = [_parentNode copyWithZone:zone];
    node->_nodes = [[NSMutableArray alloc] initWithArray:_nodes copyItems:YES];
    
    return node;
}

/*
-(NSString *)name{
    if(!_name){
        _name = [[NSString alloc] initWithString:@""];
    }
    return _name;
}
*/

@end
