extends Control


func setPower(current, consumption):
	get_node("LbPower").set_text("Power: %d (-%d)" % [max(0, current), consumption])


func setHealth(current, maxx):
	get_node("LbHealth").set_text("Health: %d/%d" % [max(0, current), maxx])



func _on_Button_pressed():
	get_node("../SwitchMenu").show()


func _on_BtnReset_pressed():
	get_node("../GM").resetLevel()
