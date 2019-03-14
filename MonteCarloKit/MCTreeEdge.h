//
//  Test.h
//  MCTSNav
//
//  Created by Philipp Schunker on 17.10.18.
//  Copyright © 2018 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCTreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTreeEdge : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSUInteger idFrom;
@property (nonatomic,assign) NSUInteger idTo;

@end

NS_ASSUME_NONNULL_END
