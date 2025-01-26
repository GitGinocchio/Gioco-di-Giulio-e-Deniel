extends StaticBody2D

var broken_block = preload("res://entities/traps/block/broken/broken.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var MAX_HIT = 3

var current_hit = 0
var colliding_top = false
var colliding_left = false
var colliding_right = false

func _on_sprite_animation_finished() -> void:
	if sprite.animation.begins_with("hit"):
		current_hit+=1
		if current_hit >= MAX_HIT:
			$AnimationPlayer.play("explosion")
			
		sprite.play("idle")

func _physics_process(delta: float) -> void:
	if $Raycasts/Top.is_colliding():
		if not colliding_top:
			colliding_top = true
			sprite.play("hit_top")
	else:
		colliding_top = false
	
	if $Raycasts/Left.is_colliding():
		if not colliding_left:
			colliding_left = true
			sprite.play("hit_side")
	else:
		colliding_left = false
	
	if $Raycasts/Right.is_colliding():
		if not colliding_right:
			colliding_right = true
			sprite.play("hit_side")
	else:
		colliding_right = false

func explode():
	var node = broken_block.instantiate()
	add_child(node)
	
	sprite.visible = false
	$CollisionShape2D.queue_free()
