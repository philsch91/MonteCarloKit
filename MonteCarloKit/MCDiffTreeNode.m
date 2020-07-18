//
//  MCDiffTreeNode.m
//  MonteCarloKit
//
//  Created by Philipp Schunker on 25.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import "MCDiffTreeNode.h"

@implementation MCDiffTreeNode

#pragma mark - IGListDiffable
 
-(nonnull id<NSObject>)diffIdentifier {
    //return self;
    return self.nid;
}
 
#pragma mark - IGListDiffable and IGListSectionController
 
-(BOOL)isEqualToDiffableObject:(id)object {
    /**
     the quickest way to get started with diffable models is use the object itself as the identifier, and use the superclass’s -[NSObject isEqual:] implementation for equality
     override NSObject methods
     return [self isEqual:object];
     */
 
    if (object == self) {
        return YES;
    }
 
    if (![object isKindOfClass:[MCTreeNode class]]) {
        return NO;
    }
 
    MCTreeNode *node = object;
 
    return [self isEqual:object]
        && self.parentNode == node.parentNode
        && [self.nodes isEqual:node.nodes];
}

/*
#pragma mark - IGListDiffable and IGListBindingSectionController
 
- (BOOL)isEqualToDiffableObject:(id)object {
 //if two models have the same diffIdentifier, they must be equal (isEqalToDiffableObject must return true) so that the section controller can then compare view models
    return true;
}
*/

@end
