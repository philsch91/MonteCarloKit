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

-(NSArray<MCTreeNode *> *)getStateUpdatesForNode:(MCTreeNode *)node level:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
