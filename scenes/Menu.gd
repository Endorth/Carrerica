extends Control

var bcount : int = 0
var rcount : int = 0
var pcount : int = 0
var gcount : int = 0
var ycount : int = 0

func _ready():
	$ConnectPanel.visible = false
	
	bcount = CDB.blue_players.size()
	rcount = CDB.red_players.size()
	pcount = CDB.purple_players.size()
	gcount = CDB.green_players.size()
	ycount = CDB.yellow_players.size()
	update_users()
	TwitchChat.connect("new_message", self, "send_data")

func send_data(data):
	if "username" in data:
		var user = data["username"]
		var msg = data["msg"]
		msg = msg.left(msg.length() - 1)
		enter_action(user, msg)
	
func update_users():
	$bluecount.text = str(bcount)
	$redcount.text = str(rcount)
	$purpcount.text = str(pcount)
	$yellcount.text = str(ycount)
	$greencount.text = str(gcount)

func enter_action(user, msg):
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


func is_new_player(user) -> bool:
	var b : bool = true
	for player in CDB.players:
		if player == user:
			b = false
			break
	return b


func _on_StartButton_pressed():
	# warning-ignore: return_value_discarded
	get_tree().change_scene("res://scenes/Carrerica.tscn")

func _on_ConnectButton_toggled(button_pressed):
	$ConnectPanel.visible = button_pressed

func _on_TextureButton_pressed():
	TwitchChat.channel = $ConnectPanel/LineEdit.text
	TwitchChat._anon_connection()

	$ConnectPanel.visible = false
	$ConnectButton.pressed = false


func _on_ResetButton_pressed():
	CDB.players = []
	CDB.blue_players = []
	CDB.red_players = []
	CDB.purple_players = []
	CDB.green_players = []
	CDB.yellow_players = []
	bcount = CDB.blue_players.size()
	rcount = CDB.red_players.size()
	pcount = CDB.purple_players.size()
	gcount = CDB.green_players.size()
	ycount = CDB.yellow_players.size()
	update_users()
