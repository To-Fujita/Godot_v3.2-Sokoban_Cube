extends WindowDialog
# Confirm Window


var popup
var Temp
var Current_Room


func _ready():
	pass 


func _on_MenuButton_pressed():
	self.show()
	Current_Room = get_node("..").Current_Room
	if get_node("..").ROOM_Result[Current_Room] == "C" and get_node("../Spatial/KinematicBody_Player").MoveData == "S" and get_node("..").Status != "Replay" and get_node("..").Status != "End":
		get_node("VBoxContainer/ButtonReplay").show()
	else:
		get_node("VBoxContainer/ButtonReplay").hide()


func _on_ButtonMenu_pressed():
	Temp = get_tree().change_scene("res://Node_Main.tscn")


func _on_ButtonNext_pressed():
	self.hide()
	get_node("..").NextGame()


func _on_ButtonSame_pressed():
	self.hide()
	get_node("..").SameGame()


func _on_ButtonNoAction_pressed():
	self.hide()


func _on_ButtonReplay_pressed():
	self.hide()
	get_node("..").Replay()


func _on_ButtonQuit_pressed():
	get_tree().quit()

