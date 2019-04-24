//
//  MCState.m
//  MonteCarloKit
//
//  Created by Philipp Schunker on 14.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

#import "MCState.h"

@implementation MCState

-(instancetype)init{
    self = [super init];
    if(self){
        //_numerator = [[NSNumber alloc] initWithInt:0];
        //_denominator = [[NSNumber alloc] initWithInt:0];
        _numerator = 0;
        _denominator = 0;
    }

    return self;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone{
    /*
     * NSObject does not itself support the NSCopying protocol.
     * Subclasses must support the protocol and implement the copyWithZone: method.
     * A subclass version of the copyWithZone: method should send the message to super first, to incorporate its implementation, unless the subclass descends directly from NSObject.
     */
    
    MCState *stateCopy = [[[self class] allocWithZone:zone] init];
    //stateCopy.numerator = [[NSNumber alloc] initWithDouble:[self.numerator doubleValue]];
    //stateCopy.denominator = [[NSNumber alloc] initWithDouble:[self.denominator doubleValue]];
    stateCopy.numerator = self.numerator;
    stateCopy.denominator = self.numerator;
    
    return stateCopy;
}

//override in subclass
-(double)compareToState:(MCState *)state{
    return 0;
}

@end
