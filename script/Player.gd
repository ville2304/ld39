extends Spatial


var mCommand = 0


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func waitForInput(command):
	if mCommand != 0:
		return false
	mCommand = command
	if mCommand != 0:
		return false
	return true


# @return true if do something
func turnPre(substep):
	return false
	if substep == 0:
		get_parent().addWait(0.6)
		return true
	return false


# @return true if defer
func turnMove(substep):
	if mCommand == 1:
		translate(Vector3(0, 0, -1))
	elif mCommand == 2:
		translate(Vector3(0, 0, 1))
	if mCommand == 3:
		translate(Vector3(-1, 0, 0))
	if mCommand == 4:
		translate(Vector3(1, 0, 0))
	mCommand = 0
	return false


func turnMoveDeferred(substep):
	pass


func turnPost(substep):
	pass

