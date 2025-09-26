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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomizer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	key_logger(lines)
	

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
			
	key_logger(lines)

#Handles Key-Control Sequence, use Match function with input vs text
func key_logger(log: Dictionary):
	var input_key : String
	
	for input in keys:
		var key = log["one"]
		if key == keys[input]:
			print("Key Match Found")
			input_key = keys[input]
			break
		else:
			continue
		
	
	match input_key:
		"q":
			print("Input: Q")
		"w":
			print("Input: W")
		"e":
			print("Input: E")
		"r":
			print("Input: R")
		"t":
			print("Input: T")
		"a":
			print("Input: A")
		"s":
			print("Input: S")
		"d":
			print("Input: D")
		"f":
			print("Input: F")
		"g":
			print("Input: G")
		"z":
			print("Input: Z")
		"x":
			print("Input: X")
		"c":
			print("Input: C")
		"v":
			print("Input: V")
		"b":
			print("Input: B")
	
