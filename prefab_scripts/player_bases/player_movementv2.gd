extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_speed: float = 5.0
@export var jbuffer_time: float = 0.2
@export var acceleration: float = 20.0
@export var air_acceleration: float = 0.8
@export var friction: float = 3.0

var jbuffer: bool = false
var input_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not self.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			self.jbuffer = true
			self.kill_jbuffer()
		self.velocity += self.get_gravity() * delta
	if (Input.is_action_just_pressed("jump") or self.jbuffer) and self.is_on_floor():
		self.velocity.y = self.jump_speed
		self.jbuffer = false
	self.input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction: Vector3 = (self.global_transform.basis * Vector3(self.input_dir.x, 0.0, self.input_dir.y)).normalized()
	if self.is_on_floor():
		var horizontal_speed: float = Vector2(self.velocity.x, self.velocity.z).length()
		if horizontal_speed > 0.0:
			var new_speed: float = maxf(horizontal_speed - maxf(horizontal_speed, self.move_speed) * self.friction * delta, 0.0)
			self.velocity.x *= new_speed / horizontal_speed
			self.velocity.z *= new_speed / horizontal_speed
	if direction != Vector3.ZERO:
		var add_speed: float = self.move_speed - Vector3(self.velocity.x, 0.0, self.velocity.z).dot(direction)
		if add_speed > 0.0:
			var accel: float = self.acceleration if self.is_on_floor() else self.air_acceleration
			var accel_speed: float = minf(accel * delta * self.move_speed, add_speed)
			self.velocity.x += direction.x * accel_speed
			self.velocity.z += direction.z * accel_speed
	self.move_and_slide()

func kill_jbuffer() -> void:
	await self.get_tree().create_timer(self.jbuffer_time).timeout
	self.jbuffer = false
