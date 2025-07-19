extends Sprite2D

@onready var interact : Label = $"Interact Label"
@onready var action_menu : Control = $Action_Choice_Panel


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false


func _on_cory_work_area_area_entered(area: Area2D) -> void:
	toggle_vis(interact)
	


func _on_cory_work_area_area_exited(area: Area2D) -> void:
	toggle_vis(interact)
	if action_menu.visible == true:
		toggle_vis(action_menu)
	


func _on_lucy_work_area_area_entered(area: Area2D) -> void:
	toggle_vis(action_menu)
	


func _on_lucy_work_area_area_exited(area: Area2D) -> void:
	toggle_vis(action_menu)
	if action_menu.visible == true:
		toggle_vis(action_menu)
		
