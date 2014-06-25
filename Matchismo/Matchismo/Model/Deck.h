//
//  Deck.h
//  Matchismo
//
//  Created by liuzhijin on 6/25/14.
//  Copyright (c) 2014 liuzhijin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
