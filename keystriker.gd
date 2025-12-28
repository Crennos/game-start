extends Control


@onready var key_line_one : Label = $"MarginContainer/HBoxContainer/Key Line"
@onready var key_line_two : Label = $"MarginContainer/HBoxContainer/Key Line2"
@onready var key_line_three : Label = $"MarginContainer/HBoxContainer/Key Line3"
@onready var key_line_four : Label = $"MarginContainer/HBoxContainer/Key Line4"
@onready var key_line_five : Label = $"MarginContainer/HBoxContainer/Key Line5"
@onready var key_line_six : Label = $"MarginContainer/HBoxContainer/Key Line6"


var keys = { "0" : "q",
	"1" : "w",
	"2" : "e",
	"3" : "r",
	"4" : "t",
	"5" : "a",
	"6" : "s",
	"7" : "d",
	"8" : "f",
	"9" : "g",
	"10" : "z",
	"11" : "x",
	"12" : "c",
	"13" : "v",
	"14" : "b"
}

var lines = {"one" : "",
"two" : "",
"three" : "",
"four" : "",
"five" : "",
"six" : "",
}

var key_check = {"one" : false,
	"two" : false,
	"three" : false,
	"four" : false,
	"five" : false,
	"six" : false
}

var target_key : String
var target_label : String
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomizer()
	key_line_one.add_theme_color_override("font_color", Color(0.0, 0.90, 0.0, 1))
#	key_line_one.add_theme_color_override("font_color", Color(0.79, 0.34, 0.2, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	key_strike(target_key, target_label)
	
	

#Handles Key Line Generation
func randomizer():
	var key_string = randi_range(3, 7)
	var key_assign = []
	
	for i in key_string:
		var key_genner = str(randi_range(0, 14))
		var key_letter = keys[key_genner]
		key_assign.append(key_letter)
		
		#print(key_letter)
		#print(key_assign)
	
#	key_line_one.text = key_assign[0]
	#print(key_assign[0])
	
	key_script(key_assign)
	

func key_script(script: Array):
	var len = len(script)
	match len:
		3:
			key_line_one.text = script[0]
			key_line_two.text = script[1]
			key_line_three.text = script[2]
			lines["one"] = script[0]
			lines["two"] = script[1]
			lines["three"] = script[2]
			#print(len)
		4:
			key_line_one.text = script[0]
			key_line_two.text = script[1]
			key_line_three.text = script[2]
			key_line_four.text = script[3]
			lines["one"] = script[0]
			lines["two"] = script[1]
			lines["three"] = script[2]
			lines["four"] = script[3]
			#print(len)
		5:
			key_line_one.text = script[0]
			key_line_two.text = script[1]
			key_line_three.text = script[2]
			key_line_four.text = script[3]
			key_line_five.text = script[4]
			lines["one"] = script[0]
			lines["two"] = script[1]
			lines["three"] = script[2]
			lines["four"] = script[3]
			lines["five"] = script[4]
			#print(len)
		6:
			key_line_one.text = script[0]
			key_line_two.text = script[1]
			key_line_three.text = script[2]
			key_line_four.text = script[3]
			key_line_five.text = script[4]
			key_line_six.text = script[5]
			lines["one"] = script[0]
			lines["two"] = script[1]
			lines["three"] = script[2]
			lines["four"] = script[3]
			lines["five"] = script[4]
			lines["six"] = script[5]
			#print(len)
			
	key_finder(lines)

#Handles Key-Control Sequence, use Match function with input vs text
func key_finder(log: Dictionary):
	var input_key : String
	var label_key : String
	
	for key in key_check:
		
		if key_check[key] == false and lines[key] != "":
			label_key = key
			break
		elif key_check[key] == true and lines[key] != "":
			continue
		else:
			break
	
	if label_key != "":
	
		for input in keys:
			var key = log[label_key]
			
			if key == keys[input]:
				input_key = keys[input]
				break
			else:
				continue
	
	target_key = input_key
	target_label = label_key
	

#Detects Input for Keys
func key_strike(key_input: String, key_item: String):
	
	if Input.is_anything_pressed() == true and pressed == false:
		pressed = true
	
		match key_input:
			"q":
				if Input.is_action_just_pressed("key_q"):
					key_color(key_item,true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"w":
				if Input.is_action_just_pressed("key_w"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"e":
				if Input.is_action_just_pressed("key_e"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"r":
				if Input.is_action_just_pressed("key_r"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"t":
				if Input.is_action_just_pressed("key_t"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"a":
				if Input.is_action_just_pressed("key_a"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"s":
				if Input.is_action_just_pressed("key_s"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"d":
				if Input.is_action_just_pressed("key_d"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"f":
				if Input.is_action_just_pressed("key_f"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"g":
				if Input.is_action_just_pressed("key_g"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"z":
				if Input.is_action_just_pressed("key_z"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"x":
				if Input.is_action_just_pressed("key_x"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"c":
				if Input.is_action_just_pressed("key_c"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"v":
				if Input.is_action_just_pressed("key_v"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
			"b":
				if Input.is_action_just_pressed("key_b"):
					key_color(key_item, true)
					key_check[key_item] = true
					key_finder(lines)
				elif Input.is_anything_pressed() == true:
					key_color(key_item, false)
					key_finder(lines)
	elif Input.is_anything_pressed() == false:
		pressed = false

#Handles modulation for correct keys
func key_color(label: String, correct: bool):
	var tween = create_tween()
	
	if correct == true:
		match label:
			"one":
				tween.tween_property(key_line_one, "modulate", Color.GREEN, 0)
			"two":
				tween.tween_property(key_line_two, "modulate", Color.GREEN, 0)
			"three":
				tween.tween_property(key_line_three, "modulate", Color.GREEN, 0)
			"four":
				tween.tween_property(key_line_four, "modulate", Color.GREEN, 0)
			"five":
				tween.tween_property(key_line_five, "modulate", Color.GREEN, 0)
			"six":
				tween.tween_property(key_line_six, "modulate", Color.GREEN, 0)
	
	else:
		match label:
			"one":
				tween.tween_property(key_line_one, "modulate", Color.RED, 0)
			"two":
				tween.tween_property(key_line_two, "modulate", Color.RED, 0)
			"three":
				tween.tween_property(key_line_three, "modulate", Color.RED, 0)
			"four":
				tween.tween_property(key_line_four, "modulate", Color.RED, 0)
			"five":
				tween.tween_property(key_line_five, "modulate", Color.RED, 0)
			"six":
				tween.tween_property(key_line_six, "modulate", Color.RED, 0)
	
	key_check[label] = true
	
