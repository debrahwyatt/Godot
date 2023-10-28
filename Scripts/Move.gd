extends CharacterBody2D

#
#
#func _input(_event):
#	if Input.is_action_pressed("Moving") and selected:
#		target_position = get_global_mouse_position()
#		direction = (target_position - position).normalized()
#		is_moving = true
#		to_target = true
#		return
#
#	if Input.is_action_just_pressed("Keyboard Movement") && selected:
#		is_moving = false
#		to_target = false
#		target_position = Vector2(-1, -1)
#
#	if to_target == false && selected:
#		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#		if direction != Vector2(0, 0): is_moving = true
#		else: is_moving = false
#
#
## This should be a state machine
#func Move(_delta):
#	if is_moving:
#		MoveToTarget(_delta)
#		move_and_slide()
#		$IdleAnimation.stop()
#		$WalkAnimation.play("Walk")
#		if energy_cur > 0: energy_cur -= energy_drain
#		if hunger_cur > 0: hunger_cur -= hunger_drain * 2
#		else: health_cur -= health_drain
#	else:
#		if energy_cur < energy_max: energy_cur += energy_drain * 3
#		if hunger_cur > 0: hunger_cur -= hunger_drain
#		if happy_cur > 0: happy_cur -= happy_drain
#		$WalkAnimation.stop()
#		$IdleAnimation.play("Idle")
#
#
#func MoveToTarget(delta):
#	position += direction * speed_cur * delta
#	if position.distance_to(target_position) < 10.0: 
#		is_moving = false
#		to_target = false
#		target_position = Vector2(-1, -1)
