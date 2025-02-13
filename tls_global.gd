extends Node

const prefix_path = "res://certs"

var cert_path = "%s/cert.crt" % prefix_path
var key_path = "%s/key.key" % prefix_path

func get_client_tls(host: String) -> TLSOptions:
	# Load the self-signed certificate
	
	var client_trusted_cas = X509Certificate.new()
	client_trusted_cas.load(cert_path)
	print("Loading %s" % cert_path)
	#var client_tls_options: TLSOptions = TLSOptions.client_unsafe(null)
	var client_tls_options: TLSOptions = TLSOptions.client(client_trusted_cas, host)
	return client_tls_options

func get_server_tls() -> TLSOptions:
	# Create a TLS server configuration.
	var server_certs = X509Certificate.new()
	server_certs.load(cert_path)
	
	var server_key = CryptoKey.new()
	server_key.load(key_path)
	
	print("Loading %s" % cert_path)
	print("Loading %s" % key_path)
	var server_tls_options = TLSOptions.server(server_key, server_certs)
	return server_tls_options

## Starts the server on exported port
func run_server(port: int, tls: TLSOptions, add_player, remove_player):
	var peer = ENetMultiplayerPeer.new()
	var out = peer.create_server(port)
	var err = peer.host.dtls_server_setup(tls)
	if err != OK: print("[server] error")
	else: print("[server] It's okay")
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print("[server] Client = *:%s" % [port])
	print("[server] Status = %s" % out)
	print("[server] Peer   = %s" % multiplayer.get_unique_id())
	return [peer, out]

## Starts the client's connection to the server
func run_client(host: String, port: int, tls: TLSOptions):
	var peer = ENetMultiplayerPeer.new()
	var out = peer.create_client(host, port)
	var err = peer.host.dtls_client_setup(host, tls)
	if err != OK: print("[server] error")
	else: print("[server] It's okay")
	peer.get_peer(1).set_timeout(0, 0, 1.5 * 1_000)
	multiplayer.multiplayer_peer = peer
	#multiplayer.server_disconnected.connect(disconnect_players)
	#multiplayer.connection_failed.connect(fail_connection)
	multiplayer.connected_to_server.connect(func(): print("Connected"))
	print("[client] Client = %s:%s" % [host, port])
	print("[client] Status = %s" % out)
	print("[client] Peer   = %s" % multiplayer.get_unique_id())
	return [peer, out]
