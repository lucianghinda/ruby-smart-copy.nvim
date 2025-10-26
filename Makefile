.PHONY: test
test:
	@./run_tests.sh

.PHONY: test-watch
test-watch:
	@echo "Watching for changes..."
	@while true; do \
		inotifywait -e modify -r lua/ tests/ 2>/dev/null || \
		fswatch -1 lua/ tests/ 2>/dev/null || \
		sleep 2; \
		clear; \
		make test; \
	done
