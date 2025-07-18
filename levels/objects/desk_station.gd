extends Sprite2D

@onready var interact : Label = $"Interact Label"


func _on_cory_work_area_area_entered(area: Area2D) -> void:
	interact.visible = true
	print("On")
	pass # Replace with function body.


func _on_cory_work_area_area_exited(area: Area2D) -> void:
	interact.visible = false
	pass # Replace with function body.


func _on_lucy_work_area_area_entered(area: Area2D) -> void:
	interact.visible = true
	pass # Replace with function body.


func _on_lucy_work_area_area_exited(area: Area2D) -> void:
	interact.visible = false
	pass # Replace with function body.
