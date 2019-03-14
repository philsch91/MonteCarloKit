//
//  Test.m
//  MCTSNav
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import "MCTreeEdge.h"

@implementation MCTreeEdge

@dynamic name;
@dynamic idFrom;
@dynamic idTo;

- (instancetype)init{
    self = [super init];
    return self;
}

#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    //return self.key;
    //return self;
    return self.name;
}

#pragma mark - IGListDiffable and IGListSectionController

- (BOOL)isEqualToDiffableObject:(id)object {
    //the quickest way to get started with diffable models is use the object itself as the identifier, and use the superclass’s -[NSObject isEqual:] implementation for equality
    //return [self isEqual:object];     //override NSObject methods
    
    if(object == self){
        return YES;
    }
    
    if(![object isKindOfClass:[MCTreeEdge class]]){
        return NO;
    }
    
    MCTreeEdge *edge = object;
    
    return [self.name isEqualToString:edge.name];
}

#pragma mark - IGListDiffable and IGListBindingSectionController
/*
 - (BOOL)isEqualToDiffableObject:(id)object {
 //if two models have the same diffIdentifier, they must be equal (isEqalToDiffableObject must return true) so that the section controller can then compare view models
 return true;
 }
 */

@end
