class_name EnemyMove
extends Resource

enum EnemyMoveKind
{
	PureDamage,
}

@export var name: String
@export var spark_image: Texture2D
@export var sound: AudioStream
@export var power: int
@export var kind: EnemyMoveKind

func enact_on_world():
	match kind:
		EnemyMoveKind.PureDamage:
			gamemanager.player_health -= power;
