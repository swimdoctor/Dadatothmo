class_name Rhythm
extends Node2D

@export var moveInventory: Array[Move] = []

@export var bpm = 120.0
@export var successThreshold = 0.15
var timePerBeat = 60/bpm
var timeTillBeat = 0
var beat = 0;

var timeSinceLastNote = 0
var noteQueue = []

var click = preload("res://Sounds/metronomeClick.mp3")



func _ready() -> void:
	print("Move Inventory: ");
	for move in moveInventory:
		print(move.getString())
	

func _process(delta):
	timeTillBeat -= delta
	timeSinceLastNote += delta
	if timeSinceLastNote > timePerBeat + successThreshold * 2:
		noteQueue.clear()
	
	if timeTillBeat <= 0:
		timeTillBeat += timePerBeat
		beat += 1
		if beat % 4 == 0:
			$ClickPlayer.pitch_scale = 1.2
		else:
			$ClickPlayer.pitch_scale = 1
		$ClickPlayer.play()
	
	var timeFromBeat = min(timeTillBeat, timePerBeat - timeTillBeat)
	timeFromBeat *= sign(timePerBeat/2 - timeTillBeat)
	
	if Input.is_action_just_pressed("up"):
		playNote(Move.Note.UP, timeFromBeat)
	if Input.is_action_just_pressed("right"):
		playNote(Move.Note.RIGHT, timeFromBeat)
	if Input.is_action_just_pressed("down"):
		playNote(Move.Note.DOWN, timeFromBeat)
	if Input.is_action_just_pressed("left"):
		playNote(Move.Note.LEFT, timeFromBeat)
	
func playNote(direction, timeFromBeat):
	print("You pressed ", Move.getNoteString(direction), " ", abs(timeFromBeat), " seconds ","early" if (timeFromBeat > 0) else "late")
	if abs(timeFromBeat) > successThreshold:
		noteQueue.clear()
		return
	
	timeSinceLastNote = 0
	noteQueue.push_front(direction)
	
	if noteQueue.size() > 4:
		noteQueue.pop_back()
	
	if beat % 4 == 0 and noteQueue.size() >= 4:
		for move in moveInventory:
			var validMove = true
			for i in range(4):
				if noteQueue[i] != move.notes[i]:
					validMove = false
			
			if validMove:
				print("YOU DID ", move.name)
			
	
	print(noteQueue)
