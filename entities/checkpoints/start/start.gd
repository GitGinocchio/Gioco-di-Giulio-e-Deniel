extends Area2D

@onready var startPosition = $StartPosition
@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().get_nodes_in_group("Player")[0]


func _ready() -> void:
	player.spawn = startPosition.global_position
	player.current_spawn = player.spawn
	player.global_position = player.current_spawn

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play('idle')

func _on_body_entered(body: Node2D) -> void:
	sprite.play('moving')

#func _on_body_exited(body: Node2D) -> void:
	#sprite.play('moving')
