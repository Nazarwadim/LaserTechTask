extends RayCast2D
class_name Laser

@export var damage:float
@export var number_can_shots_through:int
@export var deviation_factor:float
@export var exist_time_sec:float

@onready var line_2d = $Node/Line2D
@onready var laser_scene = load(scene_file_path)

var _collider_position:Vector2
var _is_collider:bool

func _ready():
	await get_tree().create_timer(exist_time_sec).timeout
	queue_free()
	
func _physics_process(_delta):
	if is_colliding():
		if not _is_collider:
			_collider_position = get_collision_point()
			var collider = get_collider()
			if collider.is_in_group("damageable"):
				if number_can_shots_through > 0:
					var direction := Vector2(cos(global_rotation), sin(global_rotation)) - \
						get_collision_normal() * deviation_factor
					number_can_shots_through -= 1
					_create_new_laser_on_tip(direction)
				collider.take_damage(damage)
			elif collider.is_in_group("mirror"):
				var direction := _reflect(-Vector2(cos(global_rotation), sin(global_rotation)), get_collision_normal())
				_create_new_laser_on_tip(direction)
		_is_collider = true
	else:
		_is_collider = false
		
	var line_points = _get_points_for_line()
	line_2d.points = line_points
	
func _create_new_laser_on_tip(direction:Vector2):
	var new_laser = laser_scene.instantiate()
	new_laser.damage = damage
	new_laser.number_can_shots_through = number_can_shots_through
	new_laser.look_at(direction)
	new_laser.deviation_factor = deviation_factor
	new_laser.position = _collider_position
	new_laser.add_exception(get_collider())
	$Node.add_child(new_laser)
	
func _get_points_for_line() -> Array:
	var line_points = []
	line_points.push_back(to_global(Vector2.ZERO))
	if _is_collider:
		line_points.push_back(_collider_position)
	else:
		line_points.push_back(to_global(target_position))
	return line_points

func _reflect(light_direction:Vector2, normal_interp:Vector2) -> Vector2:
	return 2 * normal_interp.dot(light_direction) * normal_interp - light_direction
