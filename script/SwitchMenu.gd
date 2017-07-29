extends Panel

onready var mSwCore = get_node("SwCore")
onready var mSwVisual = get_node("SwVisual")
onready var mSwAudio = get_node("SwAudio")
onready var mSwRepair = get_node("SwRepair")
onready var mSwLoco = get_node("SwLoco")
onready var mSwCombat = get_node("SwCombat")

var mSettings


func _ready():
	mSettings = {"core": 3, "visual": 3, "audio": 3, "repair": 3, "loco": 3, "combat": 3}


func __restore():
	mSwCore.set_pressed(true if mSettings["core"] > 0 else false)
	#mSwVisual.set_pressed(true if mSettings["visual"] > 0 else false)
	mSwVisual.set_val(mSettings["visual"])
	mSwAudio.set_pressed(true if mSettings["audio"] > 0 else false)
	mSwRepair.set_pressed(true if mSettings["repair"] > 0 else false)
	mSwLoco.set_pressed(true if mSettings["loco"] > 0 else false)
	mSwCombat.set_pressed(true if mSettings["combat"] > 0 else false)


func _on_Cancel_pressed():
	__restore()
	hide()


func _on_Apply_pressed():
	mSettings["core"] = 3 if mSwCore.is_pressed() else 0
	#mSettings["visual"] = 3 if mSwVisual.is_pressed() else 0
	mSettings["visual"] = mSwVisual.get_value()
	mSettings["audio"] = 3 if mSwAudio.is_pressed() else 0
	mSettings["repair"] = 3 if mSwRepair.is_pressed() else 0
	mSettings["loco"] = 3 if mSwLoco.is_pressed() else 0
	mSettings["combat"] = 3 if mSwCombat.is_pressed() else 0
	
	get_node("/root/Node/GM").applyPowerSettings(mSettings)
	hide()
