extends Node

@onready var bullet = $Bullet
@onready var arrow = $Arrow

const MIN_SCALE = 0.2  # Minimum scale of the arrow
const MAX_SCALE = 0.5  # Maximum scale of the arrow
const OFFSET = 30

func _on_bullet_position_changed(new_position):
	var screen_size = get_viewport().size
	if new_position.x < 0 or new_position.x > screen_size.x or new_position.y < 0 or new_position.y > screen_size.y:
		arrow.visible = true
		var direction_to_bullet = new_position - screen_size / 2.0
		arrow.rotation = direction_to_bullet.angle() + PI/2
		
		# Calculate the intersection of the direction with the screen's boundaries
		
		arrow.global_position = _get_intersection(screen_size / 2.0, new_position, screen_size )
		
		var max_distance = screen_size.length() / 2.0
		var distance_ratio = direction_to_bullet.length() / max_distance
		var desired_scale = lerp(MAX_SCALE, MIN_SCALE, distance_ratio)
		arrow.scale = Vector2(1,1) * max(desired_scale, 0.1)
		
	else:
		arrow.visible = false

func _get_intersection(p1, p2, screen_size):
	var left = OFFSET
	var right = screen_size.x - OFFSET
	var top = OFFSET
	var bottom = screen_size.y - OFFSET -10

	var m = (p2.y - p1.y) / (p2.x - p1.x)
	var c = p1.y - m * p1.x
	
	if p2.x > p1.x:  # Bullet moving right
		var y = m * right + c
		if y >= top and y <= bottom:
			return Vector2(right, y)
	if p2.x < p1.x:  # Bullet moving left
		var y = m * left + c
		if y >= top and y <= bottom:
			return Vector2(left, y)
	if p2.y > p1.y:  # Bullet moving down
		var x = (bottom - c) / m
		if x >= left and x <= right:
			return Vector2(x, bottom)
	if p2.y < p1.y:  # Bullet moving up
		var x = (top - c) / m
		if x >= left and x <= right:
			return Vector2(x, top)

	return screen_size / 2.0  # Fallback to center if no intersection found
