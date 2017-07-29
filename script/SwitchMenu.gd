extends Panel

onready var mSwCore = get_node("SwCore")
onready var mSwVisual = get_node("SwVisual")
onready var mSwAudio = get_node("SwAudio")
onready var mSwRepair = get_node("SwRepair")
onready var mSwLoco = get_node("SwLoco")
onready var mSwCombat = get_node("SwCombat")


func __restore(settings):
	mSwCore.set_pressed(true if settings["core"] > 0 else false)
	#mSwVisual.set_pressed(true if settings["visual"] > 0 else false)
	mSwVisual.set_val(settings["visual"])
	mSwAudio.set_pressed(true if settings["audio"] > 0 else false)
	mSwRepair.set_pressed(true if settings["repair"] > 0 else false)
	mSwLoco.set_pressed(true if settings["loco"] > 0 else false)
	mSwCombat.set_pressed(true if settings["combat"] > 0 else false)


func open(s):
	__restore(s)
	show()


func _on_Cancel_pressed():
	get_node("/root/Node/GM").closeSwitch()
	hide()


func _on_Apply_pressed():
	var settings = {}
	settings["core"] = 3 if mSwCore.is_pressed() else 0
	#settings["visual"] = 3 if mSwVisual.is_pressed() else 0
	settings["visual"] = mSwVisual.get_value()
	settings["audio"] = 3 if mSwAudio.is_pressed() else 0
	settings["repair"] = 3 if mSwRepair.is_pressed() else 0
	settings["loco"] = 3 if mSwLoco.is_pressed() else 0
	settings["combat"] = 3 if mSwCombat.is_pressed() else 0
	
	var gm = get_node("/root/Node/GM")
	gm.applyPowerSettings(settings)
	gm.closeSwitch()
	hide()
