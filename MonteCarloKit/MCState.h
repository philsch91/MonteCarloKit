//
//  MCState.h
//  MonteCarloKit
//
//  Created by Philipp Schunker on 14.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCState : NSObject <NSCopying>

//@property (nonatomic,strong) NSNumber *numerator;
//@property (nonatomic,strong) NSNumber *denominator;

@property (nonatomic,assign) double numerator;
@property (nonatomic,assign) double denominator;

- (double)compareToState:(MCState *)state;

@end

NS_ASSUME_NONNULL_END
