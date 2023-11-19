extends Node

@onready var PlayerContainer : PackedScene = preload("res://scenes/päähahmo.tscn")
@export var PlayerSpawn : Node2D
@onready var start_new_button = $Control/StartNewButton

var Player : CharacterBody2D
# Called when the node enters the scene tree for the first time.

func _ready():
	PlayerContainer = preload("res://scenes/päähahmo.tscn")
	RespawnPlayer()

func RespawnPlayer():
	Player = PlayerContainer.instantiate()
	Player.connect("Player_Dead", _on_player_dead)
	Player.global_position = PlayerSpawn.global_position
	add_child(Player)
	
func _on_player_dead():
	Player.queue_free()
	start_new_button.visible = true

func _on_start_new_button_button_up():
	if not Player:
		RespawnPlayer()
		start_new_button.visible = false
