extends TextureButton


export var team : String = ''
export var t : String = ''
export (Texture) var texture = null

signal was_pressed()

func _ready():
	$Label.text = team
	$TextureRect.texture = texture


func _on_TeamButton_toggled(button_pressed):
	emit_signal("was_pressed", self, button_pressed)
