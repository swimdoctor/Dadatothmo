class_name Moves_implement
extends Resource

"All moves return a 3 elements array in this format: [group_damage, damage, healing]
This information is used in the moves class for functionality
"
func Strike(enemies: Array[Enemy], rhythm: Rhythm):
	enemies[0].damage(rhythm.attack * self.damage)

func Fireball(enemies: Array[Enemy], rhythm: Rhythm):
	enemies[0].damage(rhythm.attack * self.damage)
	
func MagicMissile(enemies: Array[Enemy], rhythm: Rhythm):
	enemies[0].damage(rhythm.attack * self.goup_damage);
