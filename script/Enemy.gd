extends Spatial


var mTarget = null
var mHealth

func _ready():
	mHealth = 50


func getGrid():
	var trans = get_translation()
	return Vector2(floor(trans.x), floor(trans.z))


func uke(dmg):
	var ap = get_node("AnimationPlayer")
	get_parent().get_parent().addWait(ap.get_animation("Uke").get_length())
	ap.play("Uke")
	mHealth -= dmg
	

func turn(command):
	var gm = get_parent().get_parent()
	if mHealth <= 0:
		__die()
		return true
	var ap = get_node("AnimationPlayer")
	if !ap.is_playing():
		ap.play("Idle-loop")
	
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
			set_rotation(Vector3(0, getDir(rc, myPos), 0))
			__attack(gm, mTarget)
		elif tt[0]:
			set_rotation(Vector3(0, getDir(rc, myPos), 0))
			set_translation(Vector3(rc.x, 0, rc.y))
			gm.addWait(0.1)
		else:
			__roam(gm)
	return true


func getDir(nc, myPos):
	if nc.x < myPos.x:
		return PI * -.5
	elif nc.x > myPos.x:
		return PI * .5
	elif nc.y > myPos.y:
		return 0
	elif nc.y < myPos.y:
		return PI
	return 0


func __roam(gm):
	var newPos
	var tries = 0
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
		tries += 1
		if tries > 20:
			return true
	set_rotation(Vector3(0, getDir(newPos, getGrid()), 0))
	set_translation(Vector3(newPos.x, 0, newPos.y))
	gm.addWait(0.1)


func __attack(gm, target):
	var ap = get_node("AnimationPlayer")
	ap.play("Attack")
	get_parent().get_parent().addWait(ap.get_animation("Attack").get_length())


func _applyAttack():
	mTarget.uke(13)


func __die():
	var ap = get_node("AnimationPlayer")
	ap.connect("finished", self, "_applyDie", [], ap.CONNECT_ONESHOT)
	ap.play("Die")
	get_parent().get_parent().addWait(ap.get_animation("Die").get_length())


func _applyDie():
	get_parent().get_parent().kill(self)



