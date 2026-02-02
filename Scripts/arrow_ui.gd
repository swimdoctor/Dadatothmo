extends HBoxContainer

var completed_moves = 0;

# sets number of moves contained in this pattern
# TODO: allow for patterns with directions
func set_pattern(directions : Array[Move.Direction]):
	# reset pattern
	completed_moves = 0;
	for n in get_children():
		n.queue_free();
		
	# create new pattern
	for d in directions:
		var note = TextureRect.new();
		note.texture = load("res://" + Move.getNoteSpriteName(d));
		note.expand_mode = TextureRect.EXPAND_FIT_WIDTH;
		add_child(note);

# displays the next move in the pattern as completed
func increment():
	if(completed_moves < get_child_count()):
		var move = get_child(completed_moves);
		move.modulate = Color(1, 0, 0, 1);
		completed_moves += 1;

# uncompletes the latest move in the pattern
func decrement():
	if(completed_moves > 0):
		completed_moves -= 1;
		var move = get_child(completed_moves);
		move.modulate = Color(1, 1, 1, 1);

# sets number of completed moves
func set_completed_moves(num_moves : int):
	# completing moves
	while(completed_moves < num_moves && completed_moves < get_child_count()):
		increment();
	# uncompleting moves
	while(completed_moves > num_moves && completed_moves > 0):
		decrement();
	

# resets completion of displayed moves
func reset():
	for i in completed_moves:
		var move = get_child(i);
		move.modulate = Color(1, 1, 1, 1);
	completed_moves = 0;
