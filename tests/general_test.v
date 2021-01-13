import vls
import vls.testing
import lsp
import json

fn test_wrong_first_request() {
	mut io := testing.Testio{}
	mut ls := vls.new(io)
	payload := io.request('shutdown')
	ls.dispatch(payload)
	assert ls.status() == .off
	err_code, err_msg := io.response_error() or {
		assert false
		return
	}
	assert err_code == -32002
	assert err_msg == 'Server not yet initialized.'
}

fn test_initialize_with_capabilities() {
	mut io, mut ls := init()
	assert ls.status() == .initialized
	assert io.result() == json.encode(lsp.InitializeResult{})
}

fn test_initialized() {
	mut io, mut ls := init()
	payload := io.request('initialized')
	ls.dispatch(payload)
	assert ls.status() == .initialized
}

// fn test_shutdown() {
// 	payload := '{"jsonrpc":"2.0","method":"shutdown","params":{}}'
// 	mut ls := init()
// 	ls.dispatch(payload)
// 	status := ls.status()
// 	assert status == .shutdown
// }

fn init() (testing.Testio, vls.Vls) {
	mut io := testing.Testio{}
	mut ls := vls.new(io)
	payload := io.request('initialize')
	ls.dispatch(payload)
	return io, ls
}
