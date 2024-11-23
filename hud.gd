extends CanvasLayer

#sinal que ve se o jogo foi criado
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#funcao pra mostrar a mensagem
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

#mostarado quando perder, soltara um timer de 2 seg e retornara ao inicio
func show_game_over():
	show_message("Game Over")
	#espera que o timer tenha regressado
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	#faz um timer e espera ele finalizar
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
#Atualiza o placar 
func update_score(score):
	$ScoreLabel.text = str(score)
	
#comeca o jogo
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
