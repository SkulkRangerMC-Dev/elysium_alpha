extends Node
var a = 0
var b = 1
var fib_var = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	while fib_var < 1:
		fib_var = 1 + fib_var
		print(a)
		print(b)
		a = a+b
		b = b+a 
	

		
		
		
		
