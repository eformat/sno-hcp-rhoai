.PHONY: pre-commit
pre-commit:
	pre-commit run --all-files

.PHONY: yamllint
yamllint:
	python3 -m yamllint .
