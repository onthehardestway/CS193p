//
//  PlayingCard.m
//  Matchismo
//
//  Created by liuzhijin on 6/25/14.
//  Copyright (c) 2014 liuzhijin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    // if type check failed, return 0
    for (id obj in otherCards) {
        if (![obj isKindOfClass:[PlayingCard class]]) {
            return score;
        }
    }
    
    // get all cards
    NSMutableArray *allCards = [NSMutableArray arrayWithArray:otherCards];
    [allCards addObject:self];

    // calculate total score
    while ([allCards count] > 0) {
        // match between the first card and the rest cards
        PlayingCard *firstCard = [allCards firstObject];

        // remove first card
        [allCards removeObjectAtIndex:0];

        for (PlayingCard *card in allCards) {
            score += [firstCard matchAgainstCard:card];
        }
    }

    return score;
}

static const NSInteger RANK_MATCH_SCORE = 4;
static const NSInteger SUIT_MATCH_SCORE = 1;

- (NSInteger)matchAgainstCard:(PlayingCard *)card
{
    NSInteger score = 0;

    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *otherCard = card;
        if (otherCard.rank == self.rank) {
            score = RANK_MATCH_SCORE;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = SUIT_MATCH_SCORE;
        }
    }

    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter
+ (NSArray *)validSuits
{
    return @[@"♠︎", @"♥︎", @"♣︎", @"♦︎"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",
              @"J", @"Q", @"K"];
}

+ (NSUInteger)minRank
{
    return 1;
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
