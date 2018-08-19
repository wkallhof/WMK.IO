# Makefile

deploy:
ifdef AWS_ACCESS_KEY_ID
	aws --version

	# Force text/html for HTML because we're not using an extension.
	aws s3 sync ./src/www/ s3://$(S3_BUCKET)/ \
        --acl public-read --delete --content-type text/html --exclude 'assets*'

	# Then move on to assets and allow S3 to detect content type.
	aws s3 sync ./src/www/assets s3://$(S3_BUCKET)/assets/ \
        --acl public-read --delete --follow-symlinks
else
	# No AWS access key. Skipping deploy.
endif