//
//  MCState.m
//  MonteCarloKit
//
//  Created by Philipp Schunker on 14.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import "MCState.h"

@implementation MCState

- (instancetype)init{
    self = [super init];
    if(self){
        //_numerator = [[NSNumber alloc] initWithInt:0];
        //_denominator = [[NSNumber alloc] initWithInt:0];
        _numerator = 0;
        _denominator = 0;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    MCState *stateCopy = [[MCState alloc] init];
    //stateCopy.numerator = [[NSNumber alloc] initWithDouble:[self.numerator doubleValue]];
    //stateCopy.denominator = [[NSNumber alloc] initWithDouble:[self.denominator doubleValue]];
    stateCopy.numerator = self.numerator;
    stateCopy.denominator = self.numerator;
    
    return stateCopy;
}

-(double)compareToState:(MCState *)state{
    return 0;
}

@end
