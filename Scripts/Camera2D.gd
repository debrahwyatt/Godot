extends Camera2D

# Camera movement speed
var camera_speed = 500
var map_mode = false
var map_camera_start = Vector2(1000,1000)

func _process(delta):
	if map_mode == false: return
	
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()

	var camera_translation = Vector2(0, 0)

	if mouse_position.x < 10: camera_translation.x = -1
	elif mouse_position.x > viewport.size.x - 10: camera_translation.x = 1

	if mouse_position.y < 10: camera_translation.y = -1
	elif mouse_position.y > viewport.size.y - 10: camera_translation.y = 1

	camera_translation = camera_translation.normalized() * camera_speed * delta
	offset_camera(camera_translation)


func MapMode(boolean):
	map_mode = boolean
	if map_mode == true:
		offset_camera(map_camera_start)


func offset_camera(offset2):
	global_position += offset2
