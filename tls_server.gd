extends Node

var peer
var connection

func _ready():
	var tls_option = TlsGlobal.get_server_tls()
	var res = TlsGlobal.run_server(
		6666, tls_option,
		func(id): print("New     '%s'" % id),
		func(id): print("Removed '%s'" % id)
	)
	peer = res[0]
	connection = res[1]

