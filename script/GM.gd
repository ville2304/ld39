extends Node


enum Command{
	NONE,
	NORTH,
	SOUTH,
	WEST,
	EAST,
	WAIT
}



var mPlayers
onready var mLevel = get_node("Level")
var mIterator
var mWait = 0
var mCommand = Command.NONE


func addWait(seconds):
	mWait = max(mWait, seconds)


func getCell(cell):
	if !mLevel.isWalkable(cell):
		return [false, null]
	for i in mPlayers:
		if i.getGrid() == cell:
			return [false, i]
	return [true, null]


func kill(player):
	get_node("Players").remove_child(player)
	mPlayers = get_node("Players").get_children()



func raycast(x0, y0, x1, y1, maxLength):
	var xDist = abs(x1 - x0)
	var yDist = -abs(y1 - y0)
	var xStep
	if x0 < x1: xStep = 1
	else: xStep = -1
	
	var yStep
	if y0 < y1: yStep = 1
	else: yStep = -1
	
	var error = xDist + yDist
	var go = null
	var l = 0
	while x0 != x1 || y0 != y1:
		l+=1
		if l > maxLength:
			return null
		if 2 * error - yDist > xDist - 2 * error:
			error+= yDist
			x0+= xStep
		else:
			error+= xDist
			y0+= yStep
		if go == null:
			go = Vector2(x0, y0)
		
		if !mLevel.isWalkable(Vector2(x0, y0)):
			return null
	return go


func getTarget():
	return mPlayers[0]





func _ready():
	var plrs = mLevel.getPlayerStarts()
	var pn = get_node("Players")
	var user = preload("res://User.tscn")
	var enemy = preload("res://Enemy.tscn")
	for i in range(plrs.size()):
		var pos = plrs[i]
		var n
		if i == 0:
			n = user.instance()
		else:
			n = enemy.instance()
		n.set_translation(Vector3(pos.x, 0, pos.y))
		pn.add_child(n)
	
	mPlayers = pn.get_children()
	
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
	elif Input.is_key_pressed(KEY_Z):
		mCommand = Command.WAIT
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
	print("turn start")
	mIterator = 0
