extends KinematicBody
# Obstacle Move


const Speed = 2
const GRAVITY = -9.8
onready var Player = get_node("../KinematicBody_Player")
var TileSize
var XP_ray
var XM_ray
var YPN_ray
var YPF_ray
var YM_ray
var ZP_ray
var ZM_ray
var Result_XP
var Result_XM
var Result_ZP
var Result_ZM
var Direction = Vector3()
var Temp_Direction = Vector3()
var MoveFlag = 0
var Obstacle
var On_ground = true
var Result_YPN
var Result_YPF
var Result_YM
var MoveVector
var Stack_No = 0


func _ready():
	XP_ray = get_node("RayCast_XP")
	XM_ray = get_node("RayCast_XM")
	YPN_ray = get_node("RayCast_YPN")
	YPF_ray = get_node("RayCast_YPF")
	YM_ray = get_node("RayCast_YM")
	ZP_ray = get_node("RayCast_ZP")
	ZM_ray = get_node("RayCast_ZM")
	Direction = Vector3(0, 0, 0)
	Obstacle = self
	TileSize = get_node("..").Block_size


func _process(delta):
	MoveVector = Player.JoystickVector
	Result_XP = XP_ray.get_collider()
	Result_XM = XM_ray.get_collider()
	Result_ZP = ZP_ray.get_collider()
	Result_ZM = ZM_ray.get_collider()
	On_ground = YM_ray.is_colliding()
	Result_YM = YM_ray.get_collider()
	Result_YPN = YPN_ray.get_collider()
	Result_YPF = YPF_ray.get_collider()

	if MoveVector == "L" and Result_XP == Player:
		Direction = Vector3(-Speed, 0, 0)
	elif MoveVector == "R" and Result_XM == Player:
		Direction = Vector3(Speed, 0, 0)
	elif MoveVector == "F" and Result_ZP == Player:
		Direction = Vector3(0, 0, -Speed)
	elif MoveVector == "B" and Result_ZM == Player:
		Direction = Vector3(0, 0, Speed)
	else:
		Direction = Vector3(0, 0, 0)
		var Temp_X = Obstacle.global_transform.origin.x
		var Temp_Z = Obstacle.global_transform.origin.z
		Obstacle.global_transform.origin.x = floor(Temp_X / TileSize) * TileSize + TileSize / 2.0
		Obstacle.global_transform.origin.z = floor(Temp_Z / TileSize) * TileSize + TileSize / 2.0
	
	if Result_YPF != null:
		if (Result_YPF.name.substr(0, 18) == "@KinematicBody_Box" or Result_YPF.name.substr(0, 18) == "@KinematicBody_Obs"):
			MoveFlag = 0
			Stack_No = 2
			Direction = Vector3(0, 0, 0)
	if Result_YM != null:
		if (Result_YM.name.substr(0, 18) == "@KinematicBody_Box" or Result_YM.name.substr(0, 18) == "@KinematicBody_Obs") and Direction == Vector3(0, 0, 0):
			Obstacle.global_transform.origin.x = Result_YM.global_transform.origin.x
			Obstacle.global_transform.origin.y = Result_YM.global_transform.origin.y + 2
			Obstacle.global_transform.origin.z = Result_YM.global_transform.origin.z
	if Result_YPF == null:
		Stack_No = 1
		if MoveFlag <= TileSize and Direction != Vector3(0, 0, 0):
			Obstacle.move_and_slide(Direction, Vector3())
			MoveFlag = MoveFlag + delta * Speed
		elif MoveFlag > TileSize:
			MoveFlag = 0
			Direction = Vector3(0, 0, 0)
			var Temp_X = Obstacle.global_transform.origin.x
#			var Temp_Y = Obstacle.global_transform.origin.y
			var Temp_Z = Obstacle.global_transform.origin.z
			Obstacle.global_transform.origin.x = floor(Temp_X / TileSize) * TileSize + TileSize / 2.0
#			Obstacle.global_transform.origin.y = floor(Temp_Y / TileSize) * TileSize
			Obstacle.global_transform.origin.z = floor(Temp_Z / TileSize) * TileSize + TileSize / 2.0
	if !YM_ray.is_colliding() and !On_ground:
		translation.y += GRAVITY * delta
	if Result_YM != null:
		Temp_Direction = Result_YM.global_transform.origin
	if Obstacle.global_transform.origin.y < -20:
		Obstacle.global_transform.origin.y = -20

