.PHONY: all
all: start

define PROMPT
	@echo
	@echo "***********************************"
	@echo "*"
	@echo "*    $(1)"
	@echo "*"
	@echo "***********************************"
	@echo
endef

.PHONY: start
start:
	$(call PROMPT,$@)
	@docker compose up -d flipt prometheus

.PHONY: stop
stop:
	$(call PROMPT,$@)
	@docker compose down -v --remove-orphans

# export GRPC_GO_LOG_VERBOSITY_LEVEL=99
# export GRPC_GO_LOG_SEVERITY_LEVEL=info

.PHONY: run
run: start
	$(call PROMPT,$@)
	cd app && go run .

.PHONY: export
export: start
	$(call PROMPT,$@)
	@docker compose exec flipt /flipt --config=/etc/flipt/config.yml export > flags.yml

.PHONY: import
import: start
	$(call PROMPT,$@)
	@cat flags.yml | docker compose exec -T flipt /flipt --config=/etc/flipt/config.yml import --stdin
