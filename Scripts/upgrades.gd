extends Control

@export var cards: Array[Card]
@export var topcard: TextureRect
@export var leftcard: TextureRect
@export var rightcard: TextureRect

# Temporary setup for getting a feel for the upgrades screen
# Need to implement permanent moves list and stats after selection
# Make sure no duplicates / repeats
# How are we planning on storing global values
# Need a list of stats to modify from Nicholas

var card0 = null
var card1 = null
var card2 = null

func _ready():
	"""
	#card0 = cards[randi_range(0, cards.size() - 1)]
	#card1 = cards[randi_range(0, cards.size() - 1)]
	#card2 = cards[randi_range(0, cards.size() - 1)]
	
	
	print((card0 as MoveCard).move.name)
	print((card1 as MoveCard).move.name)
	print((card2 as MoveCard).move.name)
	
	if card0 is MoveCard:
		(topcard.get_child(0) as TextureRect).texture = (card0 as MoveCard).move.icon
	if card1 is MoveCard:
		(leftcard.get_child(0) as TextureRect).texture = (card1 as MoveCard).move.icon
	if card2 is MoveCard:
		(rightcard.get_child(0) as TextureRect).texture = (card2 as MoveCard).move.icon
	"""

func _process(delta):
	if Input.is_action_just_pressed("up"):
		#pickcard(card0)
		gamemanager.add_card_to_hand(load("res://Moves/MagicMissile.tres"))
		gamemanager.change_gamestate(GameManager.GameState.Fighting)
		
	if Input.is_action_just_pressed("left"):
		print("no")
		#pickcard(card1)
	if Input.is_action_just_pressed("right"):
		print("no")

func pickcard(card: Card):
	if card.cardType == Card.CardType.MOVE:
		cards.pop_at(cards.find(card0))
		# Add move to global movelist
	else:
		var statcard = card as StatCard
		print("Gained " + statcard.statValue + " " + statcard.statString)
		# Add stat to global stats
