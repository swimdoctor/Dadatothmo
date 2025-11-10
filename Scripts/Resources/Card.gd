class_name Card
extends Resource

enum CardType {
	MOVE,
	STAT
}

@export var cardType: CardType = CardType.MOVE
