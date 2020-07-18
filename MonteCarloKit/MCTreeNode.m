//
//  MCTreeNode.m
//  MonteCarloKit
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import "MCTreeNode.h"

@implementation MCTreeNode

#pragma mark - NSObject

-(instancetype)init{
    self = [super init];
    if(!self){
        return nil;
    }
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

-(NSString *)description{
    NSMutableString *descStr = [NSMutableString stringWithString:@"<"];
    [descStr appendFormat:@"%@",[super description]];
    if(self.nid != nil) {
        [descStr appendFormat:@" nid = %@",self.nid];
    }
    if(self.nodes.count > 0){
        [descStr appendFormat:@" nodes.count = %ld",self.nodes.count];
    }
    [descStr appendString:@">"];
    return [descStr copy];
}

-(NSString *)debugDescription{
    NSMutableString *descStr = [NSMutableString stringWithString:@"<"];
    [descStr appendFormat:@"%@",[super description]];
    if(self.nid != nil) {
        [descStr appendFormat:@" nid = %@",self.nid];
    }
    if(self.nodes.count > 0){
        [descStr appendFormat:@" nodes.count = %ld",self.nodes.count];
        NSUInteger i = 0;
        for(MCTreeNode *node in self.nodes){
            [descStr appendFormat:@" node %ld = %@",i,[node debugDescription]];
            i++;
        }
    }
    [descStr appendString:@">"];
    return [descStr copy];
}

#pragma mark - accessors

-(NSMutableArray<MCTreeNode *> *)nodes{
    if(!_nodes){
        _nodes = [[NSMutableArray alloc] init];
    }
    return _nodes;
}

/*
-(NSString *)name{
    if(!_name){
        _name = [[NSString alloc] initWithString:@""];
    }
    return _name;
} */

#pragma mark - public methods

-(NSMutableArray<MCTreeNode *> *)addNode:(MCTreeNode *)node{
    [self.nodes addObject:node];
    node.parentNode = self;
    return self.nodes;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone{
    MCTreeNode *node = [super copyWithZone:zone];
    if(!node){
        return nil;
    }
    node->_nid = [NSString stringWithString:_nid];
    //node->_parentNode = [_parentNode copyWithZone:zone];
    node->_parentNode = _parentNode;
    node->_nodes = [[NSMutableArray alloc] initWithArray:_nodes copyItems:YES];
    return node;
}

@end
