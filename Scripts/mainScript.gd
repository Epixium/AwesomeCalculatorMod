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
var fieldOneCombined:String
# field one vars
var fieldTwoNum1
var fieldTwoNum2
var fieldTwoCombined:String

func _ready():
	result = 0.0
	operatorIndex = operatorButton.get_selected_id()
	
	NumField1.grab_focus()

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
	if fieldOneCombined == "09" && fieldTwoCombined == "10" && operatorIndex == 0:
		result = 21
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
	if fieldTwoNum1 == null:
		fieldTwoNum1 = 0
	if fieldTwoNum2 == null:
		fieldTwoNum2 = 0
	fieldOneCombined = str(fieldOneNum1) + str(fieldOneNum2)
	fieldTwoCombined = str(fieldTwoNum1) + str(fieldTwoNum2)

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
func _on_operator_item_selected(index):
	operatorIndex = index
func _on_nd_num_field_1_item_selected(index):
	fieldTwoNum1 = index
func _on_nd_num_field_2_item_selected(index):
	fieldTwoNum2 = index

#button singals

func _on_settings_btn_pressed():
	settingsWindow.show()
	cupanAnim.play("idle")
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
	if str(result) == "nan"  || result == null || result == INF:
		resultText = ("[center]IDK[/center]")
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
	operatorIndex = 0
	fieldOneNum1 = 0
	fieldOneNum2 = 0
	fieldTwoNum1 = 0
	fieldTwoNum2 = 0
	$"1stNumField1".selected = 0
	$"1stNumField2".selected = 0
	$"operator".selected = 0
	$"2ndNumField1".selected = 0
	$"2ndNumField2".selected = 0
	
func _on_back_button_pressed():
	reset()

func _on_results_window_close_requested():
	queue_free()

func _on_close_requested():
	queue_free()
