//
//  PSMapNode.m
//  MCTSNav
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import "MCTreeNode.h"

@implementation MCTreeNode

- (instancetype)init{
    self = [super init];
    return self;
}

#pragma mark - public methods

-(NSMutableArray<MCTreeNode *> *)addNode:(MCTreeNode *)node{
    [self.nodes addObject:node];
    return self.nodes;
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

- (id)copyWithZone:(NSZone *)zone{
    MCTreeNode *node = [super copyWithZone:zone];
    node.nid = [NSString stringWithString:_nid];
    node.parentNode = [_parentNode copyWithZone:zone];
    node.nodes = [[NSMutableArray alloc] initWithArray:_nodes copyItems:YES];
    
    return node;
}

/*
#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    //return self.key;
    //return self;
    //return self.name;
    return self.nid;
}

#pragma mark - IGListDiffable and IGListSectionController

- (BOOL)isEqualToDiffableObject:(id)object {
    //the quickest way to get started with diffable models is use the object itself as the identifier, and use the superclass’s -[NSObject isEqual:] implementation for equality
    //return [self isEqual:object];     //override NSObject methods
    
    if(object == self){
        return YES;
    }
    
    if(![object isKindOfClass:[MCTreeNode class]]){
        return NO;
    }
    
    MCTreeNode *node = object;
    
    //return [self.name isEqualToString:node.name]
    return [self.nid isEqualToString:node.nid]
        && self.latitude == self.latitude
        && self.longitude == self.longitude;
}
*/

/*
#pragma mark - IGListDiffable and IGListBindingSectionController

 - (BOOL)isEqualToDiffableObject:(id)object {
 //if two models have the same diffIdentifier, they must be equal (isEqalToDiffableObject must return true) so that the section controller can then compare view models
 return true;
 }
 */

/*
-(NSString *)name{
    if(!_name){
        _name = [[NSString alloc] initWithString:@""];
    }
    return _name;
}
*/

@end
