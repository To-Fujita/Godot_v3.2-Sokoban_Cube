extends Area
# Lift Up and Down


var Speed = 4
var Tile_Size
var Lift_UP = 0
var Count = 0
var Upper = null
var Lift_oy = -5
var Lift_cy = -5
var Lift_start = 0


func _ready():
	Tile_Size = get_node("..").Block_size


func _process(delta):
	if Lift_start == 0 and get_node("..").Start_flag == 1:
		Lift_oy = get_node(".").global_transform.origin.y
		Lift_start = 1
	Lift_cy = get_node(".").global_transform.origin.y
	if Upper == null and Lift_UP == 0 and Lift_cy > Lift_oy and Count > 0:
		translation.y = Lift_cy - Speed * delta
		Count = Count - Speed * delta
	if Upper != null:
		if Lift_UP == 1 and Count < Tile_Size:
			get_node(".").translation.y = Lift_cy + Speed * delta
			if Upper.name == "KinematicBody_Player":
				Upper.global_transform.origin.y = Lift_cy + 2.4
			elif Upper.name.substr(0, 18) == "@KinematicBody_Box" or Upper.name.substr(0, 18) == "@KinematicBody_Obs":
				Upper.global_transform.origin.y = Lift_cy + 2.0
			Count = Count + Speed * delta
	if Lift_cy < Lift_oy:
		get_node(".").global_transform.origin.y = Lift_oy
	if Lift_cy > Lift_oy + Tile_Size:
		get_node(".").global_transform.origin.y = Lift_oy + Tile_Size


func _on_Area_Lift_body_entered(body):
	Upper = body
	if (body.name == "KinematicBody_Player" or body.name.substr(0, 18) == "@KinematicBody_Box" or body.name.substr(0, 18) == "@KinematicBody_Obs"):
		Lift_UP = 1
		Count = 0
		if (body.name.substr(0, 18) == "@KinematicBody_Box") or (body.name.substr(0, 18) == "@KinematicBody_Obs"):
			Upper.global_transform.origin.x = get_node(".").global_transform.origin.x
			Upper.global_transform.origin.z = get_node(".").global_transform.origin.z


func _on_Area_Lift_body_exited(body):
	Upper = null
	if (body.name == "KinematicBody_Player" or body.name.substr(0, 18) == "@KinematicBody_Box" or body.name.substr(0, 18) == "@KinematicBody_Obs"):
		Lift_UP = 0
		Count = Tile_Size

