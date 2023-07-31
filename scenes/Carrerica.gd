extends Node2D

const TEAMLAB = preload("res://scenes/TeamLabel.tscn")
onready var purple = $Snails/PurpleSnail
onready var blue = $Snails/BlueSnail
onready var red = $Snails/RedSnail
onready var yellow = $Snails/YellowSnail
onready var green = $Snails/GreenSnail

var blue_current_number : int = 0
var blue_current_user : String = ''

var red_current_number : int = 0
var red_current_user : String = ''

var green_current_number : int = 0
var green_current_user : String = ''

var yellow_current_number : int = 0
var yellow_current_user : String = ''

var purple_current_number : int = 0
var purple_current_user : String = ''

var movement : Vector2 = Vector2(96.0, 0.0)
var game_is_running : bool = false

func _ready():
	$TeamPanel.visible = false
	$WinPanel.visible = false
	for lab in $TeamPanel/ScrollContainer/VBoxContainer.get_children():
		$TeamPanel/ScrollContainer/VBoxContainer.remove_child(lab)
	
	for but in $teamscont.get_children():
		but.connect("was_pressed", self, "show_team")
	TwitchChat.connect("new_message", self, "send_data")

func send_data(data):
	if "username" in data:
		var user = data["username"]
		var msg = data["msg"]
		enter_action(user, msg)

func show_team(but, bol):
	if bol:
		for b in $teamscont.get_children():
			if b != but:
				b.pressed = false
	
	$TeamPanel.visible = bol
	fill_teams(but.t)
	
func fill_teams(c):
	for lab in $TeamPanel/ScrollContainer/VBoxContainer.get_children():
		$TeamPanel/ScrollContainer/VBoxContainer.remove_child(lab)
	match c:
		'b' : 
			for pl in CDB.blue_players:
				add_team_lab(pl, true)
		'r' : 
			for pl in CDB.red_players:
				add_team_lab(pl, true)
		'g' : 
			for pl in CDB.green_players:
				add_team_lab(pl, true)
		'y' : 
			for pl in CDB.yellow_players:
				add_team_lab(pl, true)
		'p' : 
			for pl in CDB.purple_players:
				add_team_lab(pl, true)

func add_team_lab(pl, bol):
	var l = TEAMLAB.instance()
	l.user = pl
	if bol:
		$TeamPanel/ScrollContainer/VBoxContainer.add_child(l)
	else:
		$WinPanel/ScrollContainer/VBoxContainer.add_child(l)

func snail_wins(snail):
	game_is_running = false
	var team = ''
	var winners = []
	match snail.team:
		'b' : 
			team = "BLUE"
			winners = CDB.blue_players
		'g' : 
			team = "GREEN"
			winners = CDB.green_players
		'r' : 
			team = "RED"
			winners = CDB.red_players
		'y' : 
			team = "YELLOW"
			winners = CDB.yellow_players
		'p' : 
			team = "PURPLE"
			winners = CDB.purple_players
	
	$WinPanel/Label.text = team
	for pl in winners:
		add_team_lab(pl, false)
	$WinPanel/TextureRect.texture = snail.sprite.texture
	$WinPanel.visible = true

func get_number(msg) -> int:
	var n = int(msg)
	return n

func return_to_start(snail):
	snail.global_position = snail.initial_position

func move_blue(user, msg):
	if user != blue_current_user:
		var n = get_number(msg)
		if n == blue_current_number + 1:
			blue.global_position += movement
			blue_current_number += 1
			blue_current_user = user
			if blue_current_number >= 10:
				snail_wins(blue)
		else:
			blue_current_number = 0
			return_to_start(blue)

func move_red(user, msg):
	if user != red_current_user:
		var n = get_number(msg)
		if n == red_current_number + 1:
			red.global_position += movement
			red_current_number += 1
			red_current_user = user
			if red_current_number >= 10:
				snail_wins(red)
		else:
			red_current_number = 0
			return_to_start(red)

func move_green(user, msg):
	if user != green_current_user:
		var n = get_number(msg)
		if n == green_current_number + 1:
			green.global_position += movement
			green_current_number += 1
			green_current_user = user
			if green_current_number >= 10:
				snail_wins(green)
		else:
			green_current_number = 0
			return_to_start(green)

func move_yellow(user, msg):
	if user != yellow_current_user:
		var n = get_number(msg)
		if n == yellow_current_number + 1:
			yellow.global_position += movement
			yellow_current_number += 1
			yellow_current_user = user
			if yellow_current_number >= 10:
				snail_wins(yellow)
		else:
			yellow_current_number = 0
			return_to_start(yellow)

func move_purple(user, msg):
	if user != purple_current_user:
		var n = get_number(msg)
		if n == purple_current_number + 1:
			purple.global_position += movement
			purple_current_number += 1
			purple_current_user = user
			if purple_current_number >= 10:
				snail_wins(purple)
		else:
			purple_current_number = 0
			return_to_start(purple)

func enter_action(user, msg):
	if game_is_running:
		if not is_new_player(user):
			var team = get_player_team(user)
			match team:
				'b' : move_blue(user, msg)
				'r' : move_red(user, msg)
				'g' : move_green(user, msg)
				'p' : move_purple(user, msg)
				'y' : move_yellow(user, msg)

func get_player_team(user) -> String:
	var t = ''
	if CDB.blue_players.has(user):
		t = 'b'
	elif CDB.red_players.has(user):
		t = 'r'
	elif CDB.green_players.has(user):
		t = 'g'
	elif CDB.purple_players.has(user):
		t = 'p'
	elif CDB.yellow_players.has(user):
		t = 'y'
	else:
		t = ''
	return t
	
func is_new_player(user) -> bool:
	var b : bool = true
	for player in CDB.players:
		if player == user:
			b = false
			break
	return b




func _on_MenuButton_pressed():
	# warning-ignore: return_value_discarded
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_StartButton_pressed():
	game_is_running = true
	$GUI/StartButton.disabled = true


func _on_RestartButton_pressed():
	# warning-ignore: return_value_discarded
	get_tree().reload_current_scene()
