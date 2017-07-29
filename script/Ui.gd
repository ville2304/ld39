extends Control


func setPower(current, maxx, consumption):
	get_node("LbPower").set_text("Power: %d/%d (-%d)" % [max(0, current), maxx, consumption])


func setHealth(current, maxx):
	get_node("LbHealth").set_text("Health: %d/%d" % [max(0, current), maxx])



func _on_Button_pressed():
	get_node("../SwitchMenu").show()
