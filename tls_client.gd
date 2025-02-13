extends Node

var peer
var connection
var host = "127.0.0.1"

func _ready():
	var tls_option = TlsGlobal.get_client_tls(host)
	var res = TlsGlobal.run_client(host, 6666, tls_option)
	peer = res[0]
	connection = res[1]
	
