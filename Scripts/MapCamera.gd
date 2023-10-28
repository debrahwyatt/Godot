extends Camera2D

# Camera movement speed
var camera_speed = 500
var map_camera_start = Vector2(2000,2000)

func _init():
	offset_camera(map_camera_start)

func _process(delta):
	
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()

	var camera_translation = Vector2(0, 0)

	if mouse_position.x < 10: camera_translation.x = -1
	elif mouse_position.x > viewport.size.x - 10: camera_translation.x = 1

	if mouse_position.y < 10: camera_translation.y = -1
	elif mouse_position.y > viewport.size.y - 10: camera_translation.y = 1

	camera_translation = camera_translation.normalized() * camera_speed * delta
	offset_camera(camera_translation)


func offset_camera(offset2):
	global_position += offset2
