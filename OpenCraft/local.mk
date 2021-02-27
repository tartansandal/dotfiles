
.PHONY: my.lms-watch
my.lms-watch: ## Rebuild static assets for the LMS container
	docker exec -t edx.devstack.lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && paver watch_assets lms'

# Could suppress this by pushing PYTHONDONTWRITEBYTECODE=1 to environments that 
# run the code as root, but that needs to be pushed into the docker containers.
.PHONY: my.clean-root-pyc-files
my.clean-root-pyc-files: 
	# Removing pyc files owned by root
	sudo find .. -name "*.pyc" -user 'root' -delete

# for testing
.PHONY: my.find-root-pyc-files
my.find-root-pyc-files:
	find .. -name "*.pyc" -user 'root'

# Sometimes build leaves weird workfiles lying around which block pulling the
# fresh code. Run `checkout` at top level to get us back to a sane state.
.PHONY: my.checkout-all
my.checkout-all: my.clean-root-pyc-files
	# Checking out all repos...
	@for d in $$(ls ..); do                  \
		if test -d ../$$d/.git; then         \
			echo -e "\nChecking out $$d";    \
			git -C ../$$d checkout .;        \
		else                                 \
			true;                            \
		fi;                                  \
	done
	# Checking out all repos...done

# Make sure we are running the most up2date code
my.update-all: my.checkout-all
	# Updating all repos...
	@for d in $$(ls ..); do                  \
		if test -d ../$$d/.git; then         \
			echo -e "\nChecking out $$d";    \
			git -C ../$$d pull .;            \
		else                                 \
			true;                            \
		fi;                                  \
	done
	# Updating all repos...done

# For LabXchange development
# Ensure only lms and studio are running so we don't run out of memory
.PHONY: my.labxchange
my.labxchange:               \
	requirements             \
	dev.down                 \
	dev.pull.lms+studio      \
	my.update-all            \
	dev.migrate.lms          \
	dev.migrate.studio       \
	dev.up.lms+studio        \
	dev.check.lms+studio     \
	dev.check.lms+studio
