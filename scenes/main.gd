extends Node

@onready var PlayerContainer : PackedScene = preload("res://scenes/päähahmo.tscn")
@export var PlayerSpawn : Node2D
@onready var start_new_button = $Control/StartNewButton

enum MODES { PLAY, CODE }
var Player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
var code = []
var mode : MODES
var GOD : bool = false

func _ready():
	mode = MODES.PLAY
	PlayerContainer = preload("res://scenes/päähahmo.tscn")
	RespawnPlayer()

func _input(event):
	if event is InputEventKey and event.is_released():
#		if (event.as_text() == "Shift+3"):
#			if mode == MODES.CODE:
#				mode = MODES.PLAY
#				code = []
#			else:
#				mode = MODES.CODE
#		if mode == MODES.CODE:
		code.append(event.as_text())
		if code.size() > 5:
			code.pop_front()
	match array_to_string(code):
		"IDDQD":
			if GOD:
				GOD = false
			else:
				GOD = true
			code = []
				
func RespawnPlayer():
	Player = PlayerContainer.instantiate()
	Player.connect("Player_Dead", _on_player_dead)
	Player.global_position = PlayerSpawn.global_position
	add_child(Player)
	
func _on_player_dead():
	if not GOD:
		Player.queue_free()
		start_new_button.visible = true

func _on_start_new_button_button_up():
	if not Player:
		RespawnPlayer()
		start_new_button.visible = false

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s
