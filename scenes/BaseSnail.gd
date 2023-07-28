extends Position2D

export var initial_position : Vector2 = Vector2.ZERO
export var team : String = ''
onready var sprite = $Sprite

func _ready():
	global_position = initial_position
