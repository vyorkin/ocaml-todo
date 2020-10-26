# Frontend to dune

default:
	dune build

http-server:
	dune exe ./bin_server_http/todo_server_http.exe

ws-server:
	dune exe ./bin_server_ws/todo_server_ws.exe

ws-server-chat:
	dune exe ./bin_server_ws/todo_chat_ws.exe

test:
	dune exe ./test/testsuite.exe

bench:
	./bench/runner.sh

utop:
	dune utop

fmt:
	dune build @fmt --auto-promote

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
	git clean -dfXq

.PHONY: default test bench utop fmt clean
