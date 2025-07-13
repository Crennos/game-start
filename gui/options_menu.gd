extends Control

@onready var options_menu : Control = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func _on_resolution_menu_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_window_menu_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_master_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_music_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_start_button_pressed() -> void:
	pass # Replace with function body.


func _on_default_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	toggle_vis(options_menu)
