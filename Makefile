# =============================================================================
# McKing - Atajos de desarrollo
#
# Uso: make <objetivo>   (sin objetivo muestra la ayuda)
#
# Variables que se pueden cambiar al invocar, por ejemplo:
#   make db MYSQL_USER=admin
#   make db MYSQL_PASSWORD=secreto     (si no se indica, mysql la pide)
# =============================================================================

PROYECTO_API   := src/McKing.WebApi
SOLUCION       := McKing.slnx

MYSQL          ?= mysql
MYSQLDUMP      ?= mysqldump
MYSQL_HOST     ?= localhost
MYSQL_PORT     ?= 3306
MYSQL_USER     ?= root
MYSQL_PASSWORD ?=

ifeq ($(strip $(MYSQL_PASSWORD)),)
MYSQL_PASS_FLAG := -p
else
MYSQL_PASS_FLAG := -p$(MYSQL_PASSWORD)
endif

MYSQL_FLAGS := -h $(MYSQL_HOST) -P $(MYSQL_PORT) -u $(MYSQL_USER) $(MYSQL_PASS_FLAG)

.DEFAULT_GOAL := help
.PHONY: help restore build run watch clean db db-restore db-user db-dump setup

help:
	@echo Objetivos disponibles:
	@echo   make restore      Restaura los paquetes NuGet
	@echo   make build        Compila la solución
	@echo   make run          Levanta la API en http://localhost:5172/swagger
	@echo   make watch        Levanta la API y la reinicia al guardar cambios
	@echo   make clean        Borra los binarios compilados
	@echo   make db           Crea la base con schema y datos de ejemplo [borra la base actual]
	@echo   make db-restore   Restaura el backup completo [borra la base actual]
	@echo   make db-user      Crea el usuario mcking/mcking para la aplicación
	@echo   make db-dump      Genera un backup nuevo en scripts/backup/mcking-backup.sql
	@echo   make setup        db + db-user: deja todo listo para ejecutar

# --- .NET --------------------------------------------------------------------

restore:
	dotnet restore $(SOLUCION)

build:
	dotnet build $(SOLUCION)

run:
	dotnet run --project $(PROYECTO_API)

watch:
	dotnet watch --project $(PROYECTO_API)

clean:
	dotnet clean $(SOLUCION)

# --- Base de datos -----------------------------------------------------------

db:
	$(MYSQL) $(MYSQL_FLAGS) < scripts/01-schema.sql
	$(MYSQL) $(MYSQL_FLAGS) < scripts/02-datos.sql

db-restore:
	$(MYSQL) $(MYSQL_FLAGS) < scripts/backup/mcking-backup.sql

db-user:
	$(MYSQL) $(MYSQL_FLAGS) -e "CREATE USER IF NOT EXISTS 'mcking'@'localhost' IDENTIFIED BY 'mcking'; GRANT SELECT, INSERT, UPDATE, DELETE ON mcking.* TO 'mcking'@'localhost'; FLUSH PRIVILEGES;"

# --databases y --add-drop-database agregan el DROP/CREATE DATABASE y el USE,
# así el backup se restaura en un solo paso sin editarlo a mano.
db-dump:
	$(MYSQLDUMP) $(MYSQL_FLAGS) --databases mcking --add-drop-database --single-transaction --skip-dump-date --no-tablespaces > scripts/backup/mcking-backup.sql

setup: db db-user
