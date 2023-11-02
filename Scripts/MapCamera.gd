extends Camera2D

var Map
var camera_speed = 500


func _ready():
	Map = get_parent()


func _process(delta):
	var camera_translation = Vector2(0, 0)
	
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()
	var max_x = Map.cols * Map.grid_size - viewport.size.x
	var max_y = Map.rows * Map.grid_size - viewport.size.y

	if mouse_position.x < 10 && position.x > (viewport.size.x / 2): camera_translation.x = -1
	elif mouse_position.x > (viewport.size.x) - 10 && position.x < max_x: camera_translation.x = 1

	if mouse_position.y < 10 && position.y > (viewport.size.y): camera_translation.y = -1
	elif mouse_position.y > (viewport.size.y) - 10 && position.y < max_y: camera_translation.y = 1

	camera_translation = camera_translation.normalized() * camera_speed * delta
	offset_camera(camera_translation)


func offset_camera(offset2):
	global_position += offset2
