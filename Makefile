SHELL := /bin/bash

cupdate:
	cd www && composer dump-autoload

compose:
	cd docker && ./compose up