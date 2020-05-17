extends Area


var Temp = 0


func _ready():
	pass


func _on_Area_Goal_body_entered(body):
#	print(body.name)
	if body.name.substr(0, 18) == "@KinematicBody_Box":
		Temp = get_node("..").Goal_Result
		get_node("..").Goal_Result = Temp + 1
#		print("Temp += ", get_node("..").Goal_Result)

func _on_Area_Goal_body_exited(body):
	if body.name.substr(0, 18) == "@KinematicBody_Box":
		Temp = get_node("..").Goal_Result
		get_node("..").Goal_Result = Temp - 1
#		print("Temp -= ", get_node("..").Goal_Result)
