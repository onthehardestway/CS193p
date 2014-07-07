//
//  CardGameViewController.m
//  Matchismo
//
//  Created by liuzhijin on 6/25/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *gameDescription;

@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)generateNewGame
{
    CardMatchingGame *game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    game.mode = self.modeSegmentedControl.selectedSegmentIndex + 2;
    return game;
}

- (CardMatchingGame *)game
{
    if (_game == nil) {
        _game = [self generateNewGame];
    }
    return _game;
}

- (void)startNewGame
{
    self.game = [self generateNewGame];
    [self updateUI];
    self.modeSegmentedControl.enabled = YES;
    self.gameDescription.text = @"";
}

- (IBAction)modeValueChanged:(UISegmentedControl *)sender
{
    // game at least match 2 cards, but selectedSegmentIndex start from 0
    self.game.mode = sender.selectedSegmentIndex + 2;
}

- (IBAction)touchResetButton:(UIButton *)sender
{
    // according to HIG:
    // When the most likely button performs a destructive action, it should be on the left in a two-button alert. The button that cancels this action should be on the right.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Game", @"New Game")
                                                        message:NSLocalizedString(@"Do you want to start a new game?", @"Do you want to start a new game?")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", @"OK"), NSLocalizedString(@"Cancel", @"Cancel"), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self startNewGame];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    if (self.modeSegmentedControl.enabled) {
        self.modeSegmentedControl.enabled = NO;
    }
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    self.gameDescription.text = self.game.gameDescription;
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
