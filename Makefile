.PHONY: run server all

run:
	love .

server:
	cd ./server && npm start
