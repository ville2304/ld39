extends Spatial


var mTarget
var mHealth = 2
var mPower = 100
var mPassiveConsumption = 0
var mLocoConsumption = 0
var mCombatConsumption = 0

var mCoreLevel = 0
var mRepairLevel = 0
var mLocoLevel = 0
var mCombatLevel = 0

func _ready():
	get_node("/root/Node/Ui").setHealth(mHealth, 100)


func applyPowerSettings(settings):
	mPassiveConsumption = settings["core"] + settings["visual"] + settings["audio"] + settings["repair"]
	mPassiveConsumption /= 3
	mCoreLevel = settings["core"]
	mRepairLevel = settings["repair"]
	
	mLocoConsumption = settings["loco"]
	mLocoConsumption /= 3
	mLocoLevel = settings["loco"]
	
	mCombatConsumption = settings["combat"]
	mCombatConsumption /= 3
	mCombatLevel = settings["combat"]
	
	get_node("/root/Node/Ui").setPower(mPower, 100, mPassiveConsumption)


func uke(dmg):
	mHealth -= dmg
	get_node("/root/Node/Ui").setHealth(mHealth, 100)
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
	
	__drain(mPassiveConsumption)
	if mHealth < 100:
		mHealth += mRepairLevel
		get_node("/root/Node/Ui").setHealth(mHealth, 100)
	
	if command == 5:
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
		__drain(mLocoConsumption)
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
	get_node("/root/Node/Ui").setPower(mPower, 100, mPassiveConsumption)


func __attack(target):
	mTarget = target
	var ap = get_node("AnimationPlayer")
	ap.play("attack")
	get_parent().get_parent().addWait(ap.get_animation("attack").get_length())
	__drain(mCombatConsumption)


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


