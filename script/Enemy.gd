extends Spatial


var mTarget = null


func _ready():
	pass


func getGrid():
	var trans = get_translation()
	return Vector2(floor(trans.x), floor(trans.z))


func uke(dmg):
	var ap = get_node("AnimationPlayer")
	get_parent().get_parent().addWait(ap.get_animation("uke").get_length())
	ap.play("uke")


func turn(command):
	var gm = get_parent().get_parent()
	if mTarget == null:
		mTarget = gm.getTarget()
	
	var myPos = getGrid()
	var tPos = mTarget.getGrid()
	var rc = gm.raycast(myPos.x, myPos.y, tPos.x, tPos.y, 10)
	if rc == null:
		__roam(gm)
	else:
		var tt = gm.getCell(rc)
		if tt[1] == mTarget:
			__attack(gm, mTarget)
		elif tt[0]:
			set_translation(Vector3(rc.x, 0, rc.y))
			gm.addWait(0.1)
		else:
			__roam(gm)
	return true


func __roam(gm):
	var newPos
	while true:
		var command = round(rand_range(1, 4))
		newPos = getGrid()
		if command == 1:
			newPos.y -= 1
		elif command == 2:
			newPos.y += 1
		elif command == 3:
			newPos.x -= 1
		elif command == 4:
			newPos.x += 1
		var stuff = gm.getCell(newPos)
		if stuff[0]:
			break
	set_translation(Vector3(newPos.x, 0, newPos.y))
	gm.addWait(0.1)


func __attack(gm, target):
	var ap = get_node("AnimationPlayer")
	ap.play("attack")
	get_parent().get_parent().addWait(ap.get_animation("attack").get_length())


func _applyAttack():
	mTarget.uke(1)

