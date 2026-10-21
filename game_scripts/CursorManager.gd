extends Node

var captured: bool = true:
	set(state):
		captured = state
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if state else Input.MOUSE_MODE_VISIBLE
