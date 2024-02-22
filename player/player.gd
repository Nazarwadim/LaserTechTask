extends CharacterBody2D
@export var speed:float = 500
@export var _health:float = 100

func _physics_process(_delta):
	_move()

func take_damage(damage):
	_health -= damage
	if _health <= 0:
		queue_free()

func _move():
	var direction := Input.get_vector("ui_left","ui_right", "ui_up", "ui_down").normalized()
	velocity = speed * direction
	if direction != Vector2.ZERO:
		move_and_slide()

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		var mouse_event :InputEventMouseButton = event 
		if mouse_event.button_index == 1:
			var direction := get_global_mouse_position() - global_position
			$LaserGun.shoot(direction)
