//
//  PSMapNode.h
//  MCTSNav
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCState.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTreeNode : MCState

//@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nid;
//@property (nonatomic,assign) double latitude;
//@property (nonatomic,assign) double longitude;

@property (nonatomic,strong) MCTreeNode *parentNode;

@property (nonatomic,strong) NSMutableArray<MCTreeNode *> *nodes;

-(NSMutableArray<MCTreeNode *> *)addNode:(MCTreeNode *)node;

@end

NS_ASSUME_NONNULL_END
