extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var output: RichTextLabel = $Panel/output
@onready var input: LineEdit = $Panel/input

var command_history: Array[String] = []
var history_index: int = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug") and not event.is_echo():
		self.panel.visible = !self.panel.visible
		@warning_ignore("standalone_ternary")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) if self.panel.visible else Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_viewport().set_input_as_handled()

func _on_input_text_submitted(new_text: String) -> void:
	input.text = ""
	if new_text.strip_edges().is_empty():
		return
	output.text += new_text + "\n"
