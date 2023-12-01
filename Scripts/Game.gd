extends Node2D

var Map
var Selection

var camera_speed = 300
var direction = Vector2(0,0)

func _ready():
#	Map = $Map
	Selection = $UI/Selection


func _process(delta):
#	if !is_instance_valid($MapFactory/Map): return
	if Selection.selected_list && Selection.selected_list[0].is_in_group("Players"): 
		var target_position = Selection.selected_list[0].position
		
		if (target_position - position).length() > 10.0:  # Adjust the threshold as needed
			direction = (target_position - position).normalized()
			position += direction * camera_speed * delta
		else:
			# Stop moving when close to the target
			position = target_position
	
	
#	Move camera by moving mouse to edge of screen
	var camera_translation = Vector2(0, 0)
	
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()
#	var max_x = Map.cols * Map.grid_size - viewport.size.x / 2.0
#	var max_y = Map.rows * Map.grid_size - viewport.size.y / 2.0

	if mouse_position.x < 10 && position.x > viewport.size.x / 2.0: camera_translation.x = -1
#	if mouse_position.x > viewport.size.x - 10 && position.x < max_x: camera_translation.x = 1

	if mouse_position.y < 10 && position.y > viewport.size.y / 2.0: camera_translation.y = -1
#	if mouse_position.y > viewport.size.y - 10 && position.y < max_y: camera_translation.y = 1

#	Keyboard for camera pan
	if !Selection.selected_list:
		camera_translation.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		camera_translation.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	camera_translation = camera_translation.normalized() * camera_speed * delta
	offset_camera(camera_translation)
	
#	Keep camera away from the edges
	if global_position.x < viewport.size.x / 2.0: global_position.x = viewport.size.x / 2.0
#	if global_position.x > Map.map[0].size() * 50.0 - viewport.size.x / 2.0: global_position.x = Map.map[0].size() * 50.0 - viewport.size.x / 2.0
	if global_position.y < viewport.size.y / 2.0: global_position.y = viewport.size.y / 2.0
#	if global_position.y > Map.map.size() * 50.0 - viewport.size.y / 2.0: global_position.y = Map.map.size() * 50.0 - viewport.size.y / 2.0
	

func offset_camera(offset2):
	global_position += offset2
