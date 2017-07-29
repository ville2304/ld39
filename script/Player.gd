extends Spatial


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func getGrid():
	var trans = get_translation()
	return Vector2(floor(trans.x), floor(trans.z))


func turn(command):
	if command == 0:
		return false
	
	var newPos = getGrid()
	if command == 1:
		newPos.y -= 1
	elif command == 2:
		newPos.y += 1
	elif command == 3:
		newPos.x -= 1
	elif command == 4:
		newPos.x += 1
	
	var stuff = get_parent().get_parent().getCell(newPos)
	if !stuff[0]:
		return false
	set_translation(Vector3(newPos.x, 0, newPos.y))
	get_parent().get_parent().addWait(0.1)
	return true
