extends Node2D

@export var laser_spawn:Node2D
@export var laser_scene:PackedScene
@export var start_damage:float

func shoot(direction:Vector2):
	var laser = laser_scene.instantiate()
	laser.damage = start_damage
	look_at(global_position + direction)
	laser_spawn.add_child(laser)
