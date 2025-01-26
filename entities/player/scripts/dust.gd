extends GPUParticles2D

@onready var character = get_tree().get_nodes_in_group("Player")[0]

var last_animation

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var current_animation = character.sprite.animation
	var facing_direction = -1 if character.sprite.flip_h else 1
	process_material.direction.x = facing_direction

	if current_animation != last_animation:
		if current_animation == 'idle' and last_animation == 'fall':
			one_shot = true
			emitting = true
			restart()
		#elif current_animation == 'run' and last_animation == 'idle':
			#emitting = true
			#one_shot = true
			#restart()
		elif last_animation == 'run':
			emitting = true
			one_shot = true
			restart()
	else:
		if current_animation == 'run':
			if one_shot:
				one_shot = false
			if not emitting:
				emitting = true
	
	last_animation = current_animation

func _on_finished() -> void:
	pass # Replace with function body.
