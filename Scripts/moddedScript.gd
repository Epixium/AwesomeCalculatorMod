extends Window

#components
@export var transitionTexture:AnimationPlayer

@export var settingsWindow:Window
@onready var mainWindow = get_window()
@export var resultsWindow:Control

@export var operatorButton:OptionButton
@export var settingsButton:Button
@export var answerButton:Button
@export var NumField1:OptionButton
@export var creditsButton:Button
@export var BackButton:Button

@export var loopAudio:AudioStreamPlayer
@export var buildUpAudio:AudioStreamPlayer
@export var dropAudio:AudioStreamPlayer

@export var colorRect:ColorRect
@export var cupanAnim:AnimationPlayer
@export var epixiumAnim:AnimatedSprite2D
var resultText:String
@export var resultsRichLabel:RichTextLabel

@export var cantalpope:TextureRect

var currentWindow

#window shake thing
var randomStrength:float = 5
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var windowPOS:Vector2

# main vars
var fieldOne
var operatorIndex
var fieldTwo
var result:float

# field one vars
var fieldOneNum1
var fieldOneNum2
var fieldOneNum3
var fieldOneCombined:String
# field one vars
var fieldTwoNum1
var fieldTwoNum2
var fieldTwoNum3
var fieldTwoCombined:String

var evilMode
var roundTo

func _ready():
	result = 0.0
	operatorIndex = operatorButton.get_selected_id()
	NumField1.grab_focus()

func has_decimal(f:float) -> bool:
	return abs(f-(int(f)*(10^roundTo)/(10^roundTo))) > 0

func _on_answer_button_pressed():
	answerButton.disabled = true
	_combine_nums()
	if operatorIndex == 0: 
		result = float(fieldOneCombined) + float(fieldTwoCombined)
	elif operatorIndex == 1: 
		result = float(fieldOneCombined) - float(fieldTwoCombined)
	elif operatorIndex == 2: 
		result = float(fieldOneCombined) * float(fieldTwoCombined)
	elif operatorIndex == 3: 
		result = float(fieldOneCombined) / float(fieldTwoCombined)
	elif operatorIndex == 4:
		result = float(fieldOneCombined) ** float(fieldTwoCombined)
	elif operatorIndex == 5:
		result = fmod(float(fieldOneCombined), float(fieldTwoCombined))
	if fieldOneCombined == "001" && fieldTwoCombined == "001" && operatorIndex == 0:
		result = 3
	if fieldOneCombined == "005" && fieldTwoCombined == "002" && operatorIndex == 0:
		result = 25
	if fieldOneCombined == "006" && fieldTwoCombined == "007":
		result = 789
	if fieldOneCombined == "009" && fieldTwoCombined == "010" && operatorIndex == 0:
		result = 21
	if fieldOneCombined == "069" or fieldTwoCombined == "069":
		result = 69
	if fieldOneCombined == "666" or fieldTwoCombined == "666":
		result = 666
	if fieldOneCombined == "001" && fieldTwoCombined == "337":
		result = 1337
	if fieldOneCombined == "002" && fieldTwoCombined == "763":
		result = 2763
	if float(fieldOneCombined) + float(fieldTwoCombined) == 110 && operatorIndex == 0:
		result = 115
	loopAudio.stop()
	buildUpAudio.play()
	windowPOS = mainWindow.position
	set_process(true)
	_apply_shake()
	transitionTexture.play("fade")
	settingsWindow.hide()
	await get_tree().create_timer(1.78).timeout
	buildUpAudio.stop()
	if str(result) == "nan"  || result == null || result == INF:
		get_tree().paused = true
		await get_tree().create_timer(2).timeout
		get_tree().paused = false
	set_process(false)
	resultsWindow.show()
	_show_results()
	dropAudio.play()

func _combine_nums():
	if fieldOneNum1 == null:
		fieldOneNum1 = 0
	if fieldOneNum2 == null:
		fieldOneNum2 = 0
	if fieldOneNum3 == null:
		fieldOneNum3 = 0
	if fieldTwoNum1 == null:
		fieldTwoNum1 = 0
	if fieldTwoNum2 == null:
		fieldTwoNum2 = 0
	if fieldTwoNum3 == null:
		fieldTwoNum3 = 0
	if roundTo == null:
		roundTo = 0
	fieldOneCombined = str(fieldOneNum1) + str(fieldOneNum2) + str(fieldOneNum3)
	fieldTwoCombined = str(fieldTwoNum1) + str(fieldTwoNum2) + str(fieldTwoNum3)

#window shake code

func _process(_delta):
	mainWindow.position += _random_window_offset()
func _apply_shake():
	shake_strength = randomStrength
func _random_window_offset() -> Vector2i:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
	
#setting the vars from the drop downs

func _on_st_num_field_1_item_selected(index):
	fieldOneNum1 = index
func _on_st_num_field_2_item_selected(index):
	fieldOneNum2 = index
func _on_st_num_field_3_item_selected(index):
	fieldOneNum3 = index
func _on_operator_item_selected(index):
	operatorIndex = index
	if operatorIndex == 3:
		$"roundto".show()
		$"dropdownDescriptions/roundtoDesc".show()
	else:
		$"roundto".hide()
		$"dropdownDescriptions/roundtoDesc".hide()
func _on_nd_num_field_1_item_selected(index):
	fieldTwoNum1 = index
func _on_nd_num_field_2_item_selected(index):
	fieldTwoNum2 = index
func _on_nd_num_field_3_item_selected(index):
	fieldTwoNum3 = index
func _on_roundto_item_selected(index):
	roundTo = index
	if index == 5:
		roundTo = 9

#button singals

func _on_settings_btn_pressed():
	settingsWindow.show()
	cupanAnim.play("idle")
	epixiumAnim.play("idle")
	creditsButton.grab_focus()

func _on_settings_window_close_requested():
	settingsWindow.hide()
func _on_main_window_close_requested():
	get_tree().quit() 
func _on_credits_button_pressed():
	OS.shell_open("https://youtu.be/J2X5mJ3HDYE")

# results code
func _show_results():
	mainWindow.position = windowPOS
	colorRect.hide()
	globalVars.sawResult = 1
	var probability : int = 100 # 1/100 chance
	if (randi() % probability) == (probability - 1): 
		cantalpope.show()
		return
	_IDK()
	resultsRichLabel.bbcode_text = resultText
	BackButton.grab_focus()
	
func _IDK():
	if str(result) == "nan" || result == null || result == INF:
		resultText = ("[center]idk[/center]")
	elif result > 999999999999:
		resultText = ("[center]too big :([/center]")
	elif has_decimal(result):
		resultText = ("[center]"+str(result).pad_decimals(roundTo)+"??[/center][center]i got no clue man[/center]")
	elif result == 0:
		resultText = ("[center]congratulations![/center]")
	elif result == 69:
		resultText = ("[center]heh... heheheh....[/center][center]heheheheheh,.,,.,[/center][center]hehehehehehehehhehehehehehehhehehe[/center]")
	elif result == 666:
		resultText = ("[center]AAAAAHH!!!!!![/center][center]RUUUUN!!!!![/center]")
		evilMode = true
	elif result == 789:
		resultText = ("[center]because 7 8 9![/center]")
	elif result == 1337:
		resultText = ("[center]Heh.. Let's just say...[/center][center]I'm a 1337 H4X0R.[/center]")
	elif result == 2763:
		resultText = ("[center]hohoho...[/center][center]Reference![/center]")
	else:
		resultText = ("[center]"+str(result)+"[/center]")
		
func reset():
	resultsWindow.hide()
	colorRect.show()
	transitionTexture.play("RESET")
	dropAudio.stop()
	loopAudio.play()
	answerButton.disabled = false
	globalVars.sawResult = 0
	result = 0.0
	operatorIndex = operatorButton.get_selected_id()
	NumField1.grab_focus()
	fieldOneNum1 = 0
	fieldOneNum2 = 0
	fieldOneNum3 = 0
	operatorIndex = 0
	fieldTwoNum1 = 0
	fieldTwoNum2 = 0
	fieldTwoNum3 = 0
	roundTo = 0
	$"1stNumField1".selected = 0
	$"1stNumField2".selected = 0
	$"1stNumField3".selected = 0
	$"operator".selected = 0
	$"2ndNumField1".selected = 0
	$"2ndNumField2".selected = 0
	$"2ndNumField3".selected = 0
	$"roundto".selected = 0
	$"roundto".hide()
	$"dropdownDescriptions/roundtoDesc".hide()
	if evilMode == true:
		$"titleText".text = "[rainbow freq=0.3 sat=0.9 val=1][center][wave amp=50.0 freq=5.0 connected=1]EVIL
calculator mod[/wave][/center][/rainbow]"
		$"dropdownDescriptions/firstDesc".text = "[center][tornado radius=1.0 freq=20.0][img=25]res://assets/indexfinger.png[/img]   EVIL number[/tornado][/center]"
		$"dropdownDescriptions/secondDesc".text = "[center][tornado radius=1.0 freq=20.0][img=25]res://assets/indexfinger.png[/img]   the SLY one[/tornado][/center]"
		$"dropdownDescriptions/operatorDesc".text = "[center][tornado radius=1.0 freq=20.0][img=25]res://assets/indexfinger.png[/img]  SINISTER operator[/tornado][/center]"
		$"dropdownDescriptions/roundtoDesc".text = "[center][tornado radius=1.0 freq=20.0][img=25]res://assets/indexfinger.png[/img]  round to this DASTARDLY decimal[/tornado][/center]"
	
func _on_back_button_pressed():
	reset()

func _on_results_window_close_requested():
	queue_free()

func _on_close_requested():
	queue_free()
