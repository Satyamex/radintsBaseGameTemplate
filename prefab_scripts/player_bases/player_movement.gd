class_name Player extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_speed: float = 5.0
@export var jbuffer_time: float = 0.2
@export var acceleration: float = 60.0
@export var deceleration: float = 50.0

var jbuffer: bool = false
var input_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not self.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			self.jbuffer = true
			self.kill_jbuffer()
		self.velocity += get_gravity() * delta
	if (Input.is_action_just_pressed("jump") or self.jbuffer) and self.is_on_floor():
		self.velocity.y = self.jump_speed
		self.jbuffer = false
	self.input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction: Vector3 = (global_transform.basis * Vector3(self.input_dir.x, 0.0, self.input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		self.velocity.x = move_toward(self.velocity.x, direction.x * self.move_speed, self.acceleration * delta)
		self.velocity.z = move_toward(self.velocity.z, direction.z * self.move_speed, self.acceleration * delta)
	else:
		self.velocity.x = move_toward(self.velocity.x, 0.0, self.deceleration * delta)
		self.velocity.z = move_toward(self.velocity.z, 0.0, self.deceleration * delta)
	self.move_and_slide()

func kill_jbuffer() -> void:
	await get_tree().create_timer(self.jbuffer_time).timeout
	self.jbuffer = false
