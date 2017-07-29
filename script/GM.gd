extends Node


enum Command{
	NONE,
	NORTH,
	SOUTH,
	WEST,
	EAST,
	WAIT
}

const LONG_PRESS = 0.5
var DEAD_ZONE = 100


var mPlayers
var mGoal
onready var mLevel = get_node("Level")
var mIterator
var mWait = 0
var mCommand = Command.NONE
var mVictory = false
var mCurrentLevel
var mTouchDown = Vector2()
var mPressTime = 0
var mGlitchPlayers = false
var mPowerSettings = {"core": 3, "visual": 3, "audio": 3, "repair": 3, "loco": 3, "combat":3}


func addWait(seconds):
	mWait = max(mWait, seconds)


func isGoal(cell):
	 return cell == mLevel.getGoal()


func getCell(cell):
	if !mLevel.isWalkable(cell):
		return [false, null]
	for i in mPlayers:
		if i.getGrid() == cell:
			return [false, i]
	return [true, null]


func kill(player):
	# FIXME: These must be deferred as iterator is not reset
	get_node("Players").remove_child(player)
	mPlayers = get_node("Players").get_children()


func victory():
	mVictory = true



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


func applyPowerSettings(settings):
	mPowerSettings = settings
	mPlayers[0].applyPowerSettings(settings)
	# TODO: Invoke global effects
	get_node("../CameraController").fix()
	mGlitchPlayers = false
	for p in mPlayers:
		p.show()
	if settings["visual"] <= 2:
		get_node("../CameraController").glitch()
	if settings["visual"] <= 1:
		print("Shader magic")
	if settings["visual"] == 0:
		mGlitchPlayers = true
	
	if settings["audio"] != 0:
		get_node("../Music").set_volume(1)
		get_node("../MusicGlitch").set_volume(0)
	else:
		get_node("../Music").set_volume(0)
		get_node("../MusicGlitch").set_volume(1)



func __reset():
	if mGoal != null:
		remove_child(mGoal)
	var pn = get_node("Players")
	for i in pn.get_children():
		pn.remove_child(i)
	mPlayers = null
	mLevel.reset()


func __startLevel():
	var cn = mLevel.getCenter()
	get_node("../CameraController").center(cn[0], cn[1], cn[2], cn[3])
	
	var pn = get_node("Players")
	var plrs = mLevel.getPlayerStarts()
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
	
	var goalPos = mLevel.getGoal()
	mGoal = TestCube.new()
	mGoal.set_translation(Vector3(goalPos.x + .5, 0.2, goalPos.y + .5))
	mGoal.set_scale(Vector3(.3, .3, .3))
	add_child(mGoal)
	
	applyPowerSettings(mPowerSettings)
	
	__newTurn()
	set_process(true)


func _nextLevel():
	mCurrentLevel += 1
	__reset()
	mLevel.loadLevel(mCurrentLevel)
	__startLevel()


func _ready():
	mPressTime = -1
	mCurrentLevel = 2
	__reset()
	mLevel.loadLevel(mCurrentLevel)
	__startLevel()
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.type == InputEvent.KEY && event.is_pressed():
		if event.scancode == KEY_UP:
			mCommand = Command.NORTH
		elif event.scancode == KEY_DOWN:
			mCommand = Command.SOUTH
		elif event.scancode == KEY_LEFT:
			mCommand = Command.WEST
		elif event.scancode == KEY_RIGHT:
			mCommand = Command.EAST
		elif event.scancode == KEY_Z:
			mCommand = Command.WAIT
		else:
			mCommand = Command.NONE
	
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.is_pressed():
			mTouchDown = event.pos
			mPressTime = 0
		else:
			var d = mTouchDown - event.pos
			if abs(d.y) < DEAD_ZONE / 2 && abs(d.x) >= DEAD_ZONE:
				mCommand = Command.EAST if sign(d.x) < 0 else Command.WEST
			elif abs(d.x) < DEAD_ZONE / 2 && abs(d.y) >= DEAD_ZONE:
				mCommand = Command.SOUTH if sign(d.y) < 0 else Command.NORTH
			else:
				if mPressTime >= LONG_PRESS:
					mCommand = Command.WAIT
				else:
					mCommand = Command.NONE
	elif event.type == InputEvent.MOUSE_MOTION:
		var d = mTouchDown - event.pos
		d = max(abs(d.x), abs(d.y))
		if d > DEAD_ZONE:
			mPressTime = -1



func _process(delta):
	if mPressTime >= 0:
		mPressTime += delta
	if mWait > 0:
		mWait -= delta
	else:
		if mVictory:
			get_node("../AnimationPlayer").play("changeLevel")
			set_process(false)
			return
		if mIterator >= mPlayers.size():
			__newTurn()
		if mPlayers[mIterator].turn(mCommand):
			mIterator += 1


func __newTurn():
	mIterator = 0
	mVictory = false
	mCommand = Command.NONE
	if mGlitchPlayers:
		for p in mPlayers:
			if randf() > 0.5:
				p.hide()
			else:
				p.show()
		mPlayers[0].show()
	
	
