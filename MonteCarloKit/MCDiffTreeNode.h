//
//  MCDiffTreeNode.h
//  MonteCarloKit
//
//  Created by Philipp Schunker on 25.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import <MonteCarloKit/MonteCarloKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDiffTreeNode : MCTreeNode

-(nonnull id<NSObject>)diffIdentifier;
-(BOOL)isEqualToDiffableObject:(id)object;

@end

NS_ASSUME_NONNULL_END
