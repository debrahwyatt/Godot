extends Node2D
#
#@onready var _pm = $PopupMenu
#
#enum PopupIds {
#	SHOW_LAST_MOUSE_POSITION = 0,
#	SAY_HI = 1,
#}
#
#var _last_mouse_position
#
#func _ready():
#	_pm.add_item("Show last mouse position", PopupIds.SHOW_LAST_MOUSE_POSITION)
#	_pm.add_item("Say hi", PopupIds.SAY_HI)
#
#
#func _input(event):
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
#		_last_mouse_position = get_global_mouse_position()
#		_pm.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, _pm.size.x , _pm.size.y))
#
#
#func _on_popup_menu_id_pressed(id):
#	print(id)
