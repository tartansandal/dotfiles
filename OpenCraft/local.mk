
.PHONY: my.lms-watch
my.lms-watch: ## Rebuild static assets for the LMS container
	docker exec -t edx.devstack.lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && paver watch_assets lms'

# Could suppress this by pushing PYTHONDONTWRITEBYTECODE=1 to environments that 
# run the code as root, but that needs to be pushed into the docker containers.
.PHONY: my.clean-pyc
my.clean-pyc: ## Remove all pyc files (often created as root)
	sudo find .. -name "*.pyc" -user 'root' -delete

.PHONY: my.find-root-pyc
my.pyc-find-root:
	find .. -name "*.pyc" -user 'root'

# Sometimes build leaves weird workfiles lying around which block pulling the
# fresh code. Run `checkout` at top level to get us back to a sane state.
.PHONY: my.checkout-all
my.checkout-all:
	for d in $$(ls ..); do git -C ../$$d checkout .; done
