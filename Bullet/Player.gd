extends CharacterBody2D

signal position_changed(new_position)

const SPEED = 150.0
const BOOST_FACTOR = 3
const MAX_BOOST = 400;
var BOOST_FUEL = MAX_BOOST;
const STEERING_FORCE = 100
const SLOWDOWN_FACTOR = 0.995;
const OBSTACLE_SPEED_REDUCTION = 100;

var current_speed = SPEED

func _ready():
	velocity = Vector2(1, 1) * SPEED  # Initial velocity
	current_speed = SPEED
	BOOST_FUEL = MAX_BOOST;

func boost():
	if BOOST_FUEL > 0:
		current_speed += BOOST_FACTOR
		BOOST_FUEL -= 1;
		
var viewport_rect = Rect2(Vector2.ZERO, get_viewport_rect().size)
var pointer_distance_from_edge = 20  # You can adjust this value
	
func _physics_process(_delta):
	var target_position = get_global_mouse_position()
	var desired_direction = target_position - global_position
	desired_direction = desired_direction.normalized()
	
	var current_direction = velocity.normalized()
	var cross_product = current_direction.cross(desired_direction)
	
	var distance_to_mouse = global_position.distance_to(target_position)
	var steering_modifier = clamp(distance_to_mouse / 300.0, 0.1, 1.0)
	
	var rotational_force = cross_product * 0.3 * steering_modifier # Adjust this value for desired curvature strength
	
	velocity = current_direction.rotated(rotational_force) * current_speed
	
	var angle = atan2(velocity.y, velocity.x)
	rotation = angle + PI/2
	
	current_speed *= SLOWDOWN_FACTOR
	
	if Input.is_action_pressed("ui_accept"):
		boost()
	elif BOOST_FUEL < MAX_BOOST:
		BOOST_FUEL += 1;
	if Input.is_action_pressed("reset_position"):
		global_position = Vector2(55, 150)
		_ready()
	
	print(BOOST_FUEL)
	print(current_speed)

	position += velocity * _delta 
	move_and_slide()
	emit_signal("position_changed", global_position)


func _on_wooden_wall_body_entered(body):
	if body == self:
		current_speed *= SLOWDOWN_FACTOR
