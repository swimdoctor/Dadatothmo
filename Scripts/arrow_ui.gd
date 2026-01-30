extends HBoxContainer

var completed_moves = 0;

# sets number of moves contained in this pattern
# TODO: allow for patterns with directions
func set_pattern(num_moves : int):
	# reset pattern
	completed_moves = 0;
	for n in get_children():
		n.queue_free();
		
	# create new pattern
	for n in num_moves:
		var move = ColorRect.new();
		move.set_color(Color(1, 1, 1, 1));
		move.custom_minimum_size = Vector2(50, 50);
		move.update_minimum_size();
		add_child(move);

# displays the next move in the pattern as completed
func increment():
	if(completed_moves < get_child_count()):
		var move = get_child(completed_moves);
		move.set_color(Color(1, 1, 0, 1));
		completed_moves += 1;

# resets completion of displayed moves
func reset():
	for i in completed_moves:
		var move = get_child(i);
		move.set_color(Color(1, 1, 1, 1));
	completed_moves = 0;
