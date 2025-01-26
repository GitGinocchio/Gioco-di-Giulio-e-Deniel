extends Path2D


@onready var path: PathFollow2D = $Path
@onready var body: CharacterBody2D = %Character
@onready var sprite: AnimatedSprite2D = %Sprite

@export var Speed : float = 0.5

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	path.progress += direction * Speed
	if path.progress_ratio >= 1 or path.progress_ratio <= 0:
		direction = -direction
	
	sprite.flip_h = true if direction == -1 else false
		
	#body.move_and_slide()
