extends Control

@onready var patience : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Patience_Level
@onready var perseverance : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Persevere_Level
@onready var motivation : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Motivation_Level
@onready var creativity : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Creativity_Level
@onready var focus : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Focus_Level
@onready var insight : Label = $MarginContainer/NinePatchRect/HBoxContainer/Personality_VBox/HBoxContainer/VBoxContainer2/Insight_Level
@onready var anxiety : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Anxiety_Level
@onready var lethargy : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Lethargy_Level
@onready var frailty : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Frailty_Level
@onready var stress : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Stress_Level
@onready var strain : Label =  $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Strain_Level
@onready var burnout : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Burnout_Level
@onready var depression : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Depression_Level
@onready var serenity : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Serenity_Level
@onready var heart : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Heart_Level
@onready var hope : Label = $MarginContainer/NinePatchRect/HBoxContainer/Emotions_VBox/HBoxContainer/VBoxContainer2/Hope_Level

var trait_dict = {
	"Patience" = 0,
	"Perseverance" = 0,
	"Motivation" = 0,
	"Creativity" = 0,
	"Focus" = 0,
	"Insight" = 0,
	"Anxiety" = 0,
	"Lethargy" = 0,
	"Frailty" = 0,
	"Stress" = 0,
	"Strain" = 0,
	"Burnout" = 0,
	"Depression" = 0,
	"Heart" = 0,
	"Serenity" = 0,
	"Hope" = 0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("update_stat_panel", set_character_values)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_character_values():
	var cory_traits = ProgressionBus.cory_traits
	var insight_check = trait_dict["Insight"]
	
	for stat in cory_traits:
		trait_dict[stat] = cory_traits[stat]
#		print("Updated Cory Trait: ", trait_dict[stat])
	
	patience.text = str(trait_dict["Patience"])
	perseverance.text = str(trait_dict["Perseverance"])
	motivation.text = str(trait_dict["Motivation"])
	creativity.text = str(trait_dict["Creativity"])
	focus.text = str(trait_dict["Focus"])
	insight.text = str(trait_dict["Insight"])
	serenity.text = str(trait_dict["Serenity"])
	heart.text = str(trait_dict["Heart"])
	hope.text = str(trait_dict["Hope"])
	
	negative_emotion_tracker(insight_check)


func negative_emotion_tracker(insight: int):
	var anxiety_value = trait_dict["Anxiety"]
	var lethargy_value = trait_dict["Lethargy"]
	var frailty_value = trait_dict["Frailty"]
	var stress_value = trait_dict["Stress"]
	var strain_value = trait_dict["Strain"]
	var burnout_value = trait_dict["Burnout"]
	var depression_value = trait_dict["Depression"]
	
	var negative_dict = {
		"Anxiety": anxiety_value,
		"Lethargy": lethargy_value,
		"Frailty": frailty_value,
		"Stress": stress_value,
		"Strain": strain_value,
		"Burnout": burnout_value,
		"Depression": depression_value
	}
	
	var label_list = []
	
	for negative in negative_dict:
		var trait_check = negative_dict[negative]
		var insight_result = obscure_trait(trait_check, insight)
		if insight_result is int:
			label_list.append(str(insight_result))
#			print(label_list[negative])
		else:
			label_list.append(insight_result)
		
	anxiety.text = label_list[0]
	lethargy.text = label_list[1]
	frailty.text = label_list[2]
	stress.text = label_list[3]
	strain.text = label_list[4]
	burnout.text = label_list[5]
	depression.text = label_list[6]

func obscure_trait(negative: int, insight: int):
	if insight <= 2:
		if negative <= 2:
#			print("Low")
			return "Low"
		elif negative >= 3 and negative <= 4:
			return "Medium"
		else:
			return negative
	elif insight >= 2 and insight <= 4:
		if negative <= 2:
#			print("Low")
			return "Low"
		elif negative >= 3 and negative <= 4:
			return negative
		else:
			return negative
	else:
		return negative
