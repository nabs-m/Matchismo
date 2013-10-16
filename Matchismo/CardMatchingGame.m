//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nabil Maadarani on 2013-10-12.
//  Copyright (c) 2013 Nabil Maadarani. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) int score;
@property (nonatomic) int mode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
    withNumberOfMatchingCards:(NSInteger)matchNumber
{
    self = [super init];
    
    if(self)
    {
        // Define the game mode
        self.mode = matchNumber;
        
        // Create the cards
        for(int i=0; i < cardCount; i++)
        {
            Card *card = [deck drawRandomCard];
            if(! card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        // See if flipping this card up creates a match
        {
            for(Card *otherCard in self.cards)
            {
                if(otherCard.faceUp && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore)
                    {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
