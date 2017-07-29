extends Spatial



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func waitForInput(command):
	return false


# @return true if do something
func turnPre(substep):
	return false
	if substep == 0:
		get_parent().addWait(0.6)
		return true
	return false


# @return true if defer
func turnMove(substep):
	return false


func turnMoveDeferred(substep):
	pass


func turnPost(substep):
	pass

