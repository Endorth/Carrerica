extends Control

var bcount : int = 0
var rcount : int = 0
var pcount : int = 0
var gcount : int = 0
var ycount : int = 0

func _ready():
	$ConnectPanel.visible = false
	update_users()
	
func update_users():
	$bluecount.text = str(bcount)
	$redcount.text = str(rcount)
	$purpcount.text = str(pcount)
	$yellcount.text = str(ycount)
	$greencount.text = str(gcount)

func enter_action(msg):
	var r = randi() % 10
	var user = 'endorth' + str(r)
#	var user = 'endorth4'
	if is_new_player(user):
		if msg.begins_with("!join "):
			msg.erase(0, 6)
			CDB.players.append(user)
			match msg:
				"b" : 
					CDB.blue_players.append(user)
					bcount += 1
				"r" : 
					CDB.red_players.append(user)
					rcount += 1
				"g" : 
					CDB.green_players.append(user)
					gcount += 1
				"y" : 
					CDB.yellow_players.append(user)
					ycount += 1
				"p" : 
					CDB.purple_players.append(user)
					pcount += 1
			
			update_users()


	$SendButton/LineEdit.clear()

func is_new_player(user) -> bool:
	var b : bool = true
	for player in CDB.players:
		if player == user:
			b = false
			break
	return b



func _on_SendButton_pressed():
	enter_action($SendButton/LineEdit.text)


func _on_StartButton_pressed():
	# warning-ignore: return_value_discarded
	get_tree().change_scene("res://scenes/Carrerica.tscn")

func _on_ConnectButton_toggled(button_pressed):
	$ConnectPanel.visible = button_pressed

func _on_TextureButton_pressed():
	$ConnectPanel.visible = false
	$ConnectButton.pressed = false
