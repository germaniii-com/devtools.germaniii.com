init:
	docker compose up -d
	docker compose exec devtools.germaniii.com npm install
	docker compose exec devtools.germaniii.com npm run build

dev:
	docker compose up -d
	docker compose exec devtools.germaniii.com npm run dev

build:
	docker compose exec devtools.germaniii.com npm run build

lint: 
	docker compose exec devtools.germaniii.com npm run lint

