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

var move0: Move;
var move1: Move;
var move2: Move;


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
	
	#generate_card("LeftCard", move0);
	#generate_card("TopCard", move1);
	#generate_card("RightCard", move2);
	generate_cards();

func _process(delta):
	if Input.is_action_just_pressed("up"):
		#pickcard(card0)
		gamemanager.add_card_from_name(movelist.MoveName.get((move1.name.to_upper().replace(" ", "_"))));
		gamemanager.change_gamestate(GameManager.GameState.Fighting)
		
	if Input.is_action_just_pressed("left"):
		#pickcard(card1)
		gamemanager.add_card_from_name(movelist.MoveName.get((move0.name.to_upper().replace(" ", "_"))));
		gamemanager.change_gamestate(GameManager.GameState.Fighting);
	if Input.is_action_just_pressed("right"):
		gamemanager.add_card_from_name(movelist.MoveName.get((move2.name.to_upper().replace(" ", "_"))));
		gamemanager.change_gamestate(GameManager.GameState.Fighting);

func generate_card(cardName: String, move: Move):
	move = movelist.new_move(movelist.random_move());
	
	get_node(cardName + "/Icon").texture = move.icon;
	get_node(cardName + "/Title").text = move.name;
	get_node(cardName + "/Description").text = move.description;

func generate_cards():
	#move0
	move0 = movelist.new_move(movelist.random_move());
	get_node("LeftCard/Icon").texture = move0.icon;
	get_node("LeftCard/Title").text = move0.name;
	get_node("LeftCard/Description").text = move0.description;

	#move1
	move1 = movelist.new_move(movelist.random_move());
	get_node("TopCard/Icon").texture = move1.icon;
	get_node("TopCard/Title").text = move1.name;
	get_node("TopCard/Description").text = move1.description;

	#move2
	move2 = movelist.new_move(movelist.random_move());
	get_node("RightCard/Icon").texture = move2.icon;
	get_node("RightCard/Title").text = move2.name;
	get_node("RightCard/Description").text = move2.description;


func pickcard(card: Card):
	if card.cardType == Card.CardType.MOVE:
		cards.pop_at(cards.find(card0))
		# Add move to global movelist
	else:
		var statcard = card as StatCard
		print("Gained " + statcard.statValue + " " + statcard.statString)
		# Add stat to global stats
