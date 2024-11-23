extends Area2D

#um sinal que enviara, quando ele bater em um inimigo
signal hit 
#usando esse export, nós definimos que a variavel poderá ser alterada pelas propriedades
@export var speed = 400 #definindo a speed do perso
var screen_size #tamanho da tela


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	#detecta se esta clicando e move na direcao
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if 	Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	#checa se o player esta andando, e entao mandamos ele fazer a animacao
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # o $ é uma abreviacao de get_node()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) #clamp limita do player de sair daquela area, onde passamos
	#o parametro 0 e o tamanho da tela, entao o player nao saira da tela do game
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	

#funcao para detectar a colisao
func _on_body_entered(body):
	hide() # o player desaparece appos ser hitado
	hit.emit()
	# aqui desabilita a colisao pra nao bugar
	$CollisionShape2D.set_deferred("disabled", true)

#funcao que chamamos para resetar o player quando comeca um novo game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
