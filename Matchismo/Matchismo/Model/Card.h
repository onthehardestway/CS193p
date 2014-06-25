//
//  Card.h
//  Matchismo
//
//  Created by liuzhijin on 6/25/14.
//  Copyright (c) 2014 liuzhijin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (NSInteger)match:(NSArray *)otherCards;
@end
