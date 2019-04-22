//
//  MCStateDelegate.h
//  MonteCarloKit
//
//  Created by Philipp Schunker on 14.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCStateDelegate <NSObject>

@required

- (NSArray<MCTreeNode *> *)getStateUpdatesForNode:(MCTreeNode *)node depth:(NSUInteger)depth;
- (double)evaluate:(MCTreeNode *)currentNode withNode:(MCTreeNode *)simNode;

@end

NS_ASSUME_NONNULL_END
