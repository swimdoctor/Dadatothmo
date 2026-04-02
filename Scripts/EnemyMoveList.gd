class_name EnemyMoveList
extends Node

enum EnemyMoveName {
	STRIKE,
	OTHER
}

func get_enemy_move(enemy_move_name : EnemyMoveName) -> EnemyMove:
	return new_enemy_move(enemy_move_name);

func new_enemy_move(enemy_move : EnemyMoveName):
	var name : String;
	var path : String;
	var method : String;
	var description : String;
	
	match enemy_move:
		EnemyMoveName.STRIKE: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			method = "strike";
			description = "Deals 30 damage.";
			
		EnemyMoveName.OTHER: 
			name = "Strike";
			path = "res://Images/Test/IconRoughSword.png";
			method = "strike";
			description = "Deals 30 damage.";

	return EnemyMove.new(enemy_move, name, description, load(path), Callable(self, method));

# deal 30 damage to player
func strike(enemies : Array[Enemy], rhythm : Rhythm):
	gamemanager.damage_player(30)
