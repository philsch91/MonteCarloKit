//
//  MCTreeNode.h
//  MonteCarloKit
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCState.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTreeNode : MCState <NSCopying>

//@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nid;
@property (nonatomic,weak) MCTreeNode *parentNode;
@property (nonatomic,strong) NSMutableArray<MCTreeNode *> *nodes;

-(NSMutableArray<MCTreeNode *> *)addNode:(MCTreeNode *)node;

@end

NS_ASSUME_NONNULL_END
