extends Node


enum Command{
	NONE,
	NORTH,
	SOUTH,
	WEST,
	EAST
}



onready var mPlayers = get_children()
var mIterator
var mWait = 0
var mCommand = Command.NONE


func addWait(seconds):
	mWait = max(mWait, seconds)



func _ready():
	__newTurn()
	set_process(true)


func _process(delta):
	if Input.is_key_pressed(KEY_UP):
		mCommand = Command.NORTH
	elif Input.is_key_pressed(KEY_DOWN):
		mCommand = Command.SOUTH
	elif Input.is_key_pressed(KEY_LEFT):
		mCommand = Command.WEST
	elif Input.is_key_pressed(KEY_RIGHT):
		mCommand = Command.EAST
	else:
		mCommand = Command.NONE
	
	
	if mWait > 0:
		mWait -= delta
	else:
		if mIterator >= mPlayers.size():
			__newTurn()
		if mPlayers[mIterator].turn(mCommand):
			mIterator += 1



func __newTurn():
	print("Turn start")
	mIterator = 0
