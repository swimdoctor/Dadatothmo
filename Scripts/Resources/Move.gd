class_name Move
extends Resource

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	REST
}

@export var name: String = ""
@export var icon: Texture2D = null
@export var notes: Array[Direction] = []
@export var damage: float
@export var group_damage: float
@export var element: String
# effects don't exist, but here's my idea for putting them in attacks
# you would select an effect from a dropdown and each one would take
# number arguments for things and everything is peachy
# but they dont exist yet so I cant implement them
# @export var enemyEffects: Array[Effect]

@export var heal: float

func _init(name = "", icon = null, notes: Array[Direction] = []):
	self.icon = icon
	self.name = name
	self.notes = notes

func getString():
	var string = "%-12s" %name;
	string = string + ": "
	for note in notes:
		string = string + getNoteString(note) + " "
	return string

static func getNoteString(note: Direction):
	match note:
		Direction.UP:
			return "UP   "
		Direction.DOWN:
			return "DOWN "
		Direction.LEFT:
			return "LEFT "
		Direction.RIGHT:
			return "RIGHT"
	
	return "Invalid"


static func getNoteSpriteName(direction: Direction):
	match direction:
		Direction.UP:
			return "Images/Test/Arrow_Up.png"
		Direction.DOWN:
			return "Images/Test/Arrow_Down.png"
		Direction.LEFT:
			return "Images/Test/Arrow_Left.png"
		Direction.RIGHT:
			return "Images/Test/Arrow_Right.png"

static func getHitNoteSpriteName(direction: Direction):
	match direction:
		Direction.UP:
			return "Images/Test/Arrow_Up_Hit.png";
		Direction.DOWN:
			return "Images/Test/Arrow_Down_Hit.png";
		Direction.LEFT:
			return "Images/Test/Arrow_Left_Hit.png";
		Direction.RIGHT:
			return "Images/Test/Arrow_Right_Hit.png";

func recover(amount):
	gamemanager.player_health += amount
	
func do_move(enemies: Array[Enemy], rhythm: Rhythm):
	# Damage calculation: Damage% * attack Stat * elemental multiplier(not added yet)
	for enemy in enemies:
		enemy.damage(group_damage * rhythm.attack)
	
	# if there were a targeted enemy, this would
	# affect them. but theres not a system for that
	# so we get enemy[0]
	var target: Enemy = enemies[0]
	
	target.damage(damage * rhythm.attack)
	recover(heal) #If the move has a heal amount recover the hp
	
	# and then if the player existed we'd apply effects to them too
	return
