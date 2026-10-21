extends Node3D

@export var cam_sens = 0.25
@export var xrot_clamp: Vector2 = Vector2(-85, 85)
@onready var player_body: CharacterBody3D = $".."

var game_paused: bool = false

func _ready() -> void:
	CursorManager.captured = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and CursorManager.captured:
		player_body.rotate_y(-event.relative.x * self.cam_sens / 100)
		self.rotate_x(-event.relative.y * self.cam_sens / 100)
		self.rotation.x = clamp(self.rotation.x, deg_to_rad(self.xrot_clamp.x), deg_to_rad(self.xrot_clamp.y))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		CursorManager.captured = !CursorManager.captured
