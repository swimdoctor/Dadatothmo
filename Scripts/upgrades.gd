extends Control

@export var cards: Array[Card] = []
@export var topcard: TextureRect
@export var leftcard: TextureRect
@export var rightcard: TextureRect

# Temporary setup for getting a feel for the upgrades screen
# Need to implement permanent moves list and stats after selection
# Make sure no duplicates / repeats
# How are we planning on storing global values

var card0 = null
var card1 = null
var card2 = null

func ready_():
	card0 = cards[randi_range(0, cards.size())]
	card1 = cards[randi_range(0, cards.size())]
	card2 = cards[randi_range(0, cards.size())]
	(topcard.get_child(0) as TextureRect).texture = card1.icon
	(leftcard.get_child(0) as TextureRect).texture = card1.icon
	(rightcard.get_child(0) as TextureRect).texture = card1.icon

func _process(delta):
	if Input.is_action_pressed("up"):
		pickcard(card0)
		
		
	if Input.is_action_pressed("left"):
		pickcard(card1)
	if Input.is_action_pressed("right"):
		pickcard(card2)

func pickcard(card: Card):
	if card.cardTyoe == Card.CardType.MOVE:
		cards.pop_at(cards.find(card0))
		# Add move to global movelist
	else:
		var statcard = card as StatCard
		print("Gained " + statcard.statValue + " " + statcard.statString)
		# Add stat to global stats
