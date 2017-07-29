extends Spatial


var mTarget
var mHealth = 2
var mPower = 10


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func uke(dmg):
	mHealth -= dmg
	var ap = get_node("AnimationPlayer")
	get_parent().get_parent().addWait(ap.get_animation("uke").get_length())
	ap.play("uke")


func getGrid():
	var trans = get_translation()
	return Vector2(floor(trans.x), floor(trans.z))


func turn(command):
	if mHealth <= 0:
		__die()
		return true
	if mPower <= 0:
		return true
	
	if get_parent().get_parent().isGoal(getGrid()):
		get_parent().get_parent().victory()
		var ap = get_node("AnimationPlayer")
		get_parent().get_parent().addWait(ap.get_animation("victory").get_length())
		ap.play("victory")
		return false
	
	if command == 0:
		return false
	elif command == 5:
		__drain(1)
		return true
	
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
	if stuff[0]:
		__drain(1)
		set_translation(Vector3(newPos.x, 0, newPos.y))
		get_parent().get_parent().addWait(0.1)
	else:
		if stuff[1] != null:
			__attack(stuff[1])
		else:
			return false
	return true


func __drain(amount):
	mPower -= amount


func __attack(target):
	mTarget = target
	var ap = get_node("AnimationPlayer")
	ap.play("attack")
	get_parent().get_parent().addWait(ap.get_animation("attack").get_length())
	__drain(1)


func _applyAttack():
	mTarget.uke(1)
	pass


func __die():
	var ap = get_node("AnimationPlayer")
	ap.connect("finished", self, "_applyDie", [], ap.CONNECT_ONESHOT)
	ap.play("die")
	get_parent().get_parent().addWait(ap.get_animation("die").get_length())


func _applyDie():
	get_parent().get_parent().kill(self)


