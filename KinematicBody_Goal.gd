extends KinematicBody
# Goal, Not use the GoalFlag in this Sokoban


var GoalFlag
var Result_YP
var YP_Ray


func _ready():
	YP_Ray = get_node("RayCast_YP")
	GoalFlag = 0


func _process(_delta):
	Result_YP = YP_Ray.get_collider()
	if Result_YP != null:
		if Result_YP.name.substr(0, 18) == "@KinematicBody_Box" and Result_YP.MoveFlag == 0:
			GoalFlag = 1
		else:
			GoalFlag = 0

