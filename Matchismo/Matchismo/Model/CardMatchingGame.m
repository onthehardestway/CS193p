//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by liuzhijin on 7/2/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;  // of Card
@property (nonatomic, readwrite) NSString *gameDescription;
@property (nonatomic, strong, readwrite) NSMutableArray *history; // of gameDescription
@end

@implementation CardMatchingGame
- (NSMutableArray *)cards
{
    if (_cards == nil) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableArray *)history
{
    if (_history == nil) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (void)setGameDescription:(NSString *)gameDescription
{
    _gameDescription = gameDescription;
    [self.history addObject:_gameDescription];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];  // super's designated initializer
    if (self) {
        for (NSInteger i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

static const NSInteger MISMATCH_PENALTY = 2;
static const NSInteger MATCH_BONUS = 4;
static const NSInteger COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        NSMutableArray *targetCards = [NSMutableArray array];
        for (Card *otherCard in self.cards) {
            if (otherCard != card && otherCard.isChosen && !otherCard.isMatched) {
                [targetCards addObject:otherCard];
            }
        }

        if (card.isChosen) {
            card.chosen = NO;
            self.gameDescription = [NSString stringWithFormat:@"%@", [targetCards componentsJoinedByString:@" "]];
        } else {
            // match against other chosen cards according to mode
            // ONLY when number of chosen cards == self.mode
            // there can be a match
            if ([targetCards count] == self.mode - 1) {
                NSInteger matchScore = [card match:targetCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *targetCard in targetCards) {
                        targetCard.matched = YES;
                    }
                    card.matched = YES;
                    self.gameDescription = [NSString stringWithFormat:@"Matched %@ %@ for %d points.", [targetCards componentsJoinedByString:@" "], card.contents, matchScore];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *targetCard in targetCards) {
                        targetCard.chosen = NO;
                    }
                    self.gameDescription = [NSString stringWithFormat:@"%@ %@ don’t match! %d point penalty!", [targetCards componentsJoinedByString:@" "], card.contents, MISMATCH_PENALTY];
                }                
            } else {
                self.gameDescription = [NSString stringWithFormat:@"%@ %@", [targetCards componentsJoinedByString:@" "], card.contents];
            }

            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
