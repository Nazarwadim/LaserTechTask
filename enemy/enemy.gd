extends CharacterBody2D

@export var _health:float = 100

func take_damage(damage:float):
	_health -= damage
	if _health <= 0:
		queue_free()
