class_name Card
extends Resource

enum CardType {
	MOVE,
	STAT
}

@export var cardTyoe: CardType = CardType.MOVE
