#!/bin/bash
# install mysql client
apt-get update -y
apt-get install -y default-mysql-client

# Install wp-cli
curl -O 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Install s3 extension for static content
init(){
	sleep 5
	echo "Init plugins..."
	wp core install --allow-root \
		--title="${SITE_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--url="${WORDPRESS_URL}"

	wp plugin install --allow-root amazon-s3-and-cloudfront
	wp plugin activate --allow-root amazon-s3-and-cloudfront

	# Configure s3 extension
	echo 'UPDATE wp_options SET option_value = '"'"'a:18:{s:13:"access-key-id";s:0:"";s:6:"bucket";s:21:"${ static_content_bucket }";s:10:"cloudfront";s:29:"${ cloudfront_distribution_dns }";s:10:"copy-to-s3";s:1:"1";s:6:"domain";s:10:"cloudfront";s:20:"enable-object-prefix";s:1:"1";s:11:"force-https";s:1:"0";s:13:"manual_bucket";b:1;s:13:"object-prefix";s:2:"wp";s:17:"object-versioning";s:1:"1";s:17:"post_meta_version";i:7;s:8:"provider";s:3:"aws";s:6:"region";s:9:"${ current_region }";s:17:"remove-local-file";s:1:"1";s:17:"secret-access-key";s:0:"";s:13:"serve-from-s3";s:1:"1";s:16:"use-server-roles";s:1:"1";s:21:"use-yearmonth-folders";s:1:"1";}'"'"' WHERE option_name = '"'"'tantan_wordpress_s3'"'"';' \
	> amazon-s3-and-cloudfront.config.sql.tmp
	echo 'UPDATE wp_options SET option_value = '"'"'a:1:{s:21:"${ static_content_bucket }";s:9:"${ current_region }";}'"'"' WHERE option_name = '"'"'_site_transient_as3cf_regions_cache'"'"';' \
	>> amazon-s3-and-cloudfront.config.sql.tmp
	echo "s/"'${ static_content_bucket }'"/dev-cloud-1-wp-static/g; s/"'${ current_region }'"/${CURRENT_REGION}/g; s/"'${ cloudfront_distribution_dns }'"/${CLOUDFRONT_DISTRIBUTION_DNS}/g; s/"'${ static_content_key_prefix }'"/static/g"
	sed "s/"'${ static_content_bucket }'"/dev-cloud-1-wp-static/g; s/"'${ current_region }'"/${CURRENT_REGION}/g; s/"'${ cloudfront_distribution_dns }'"/${CLOUDFRONT_DISTRIBUTION_DNS}/g; s/"'${ static_content_key_prefix }'"/static/g" amazon-s3-and-cloudfront.config.sql.tmp  > amazon-s3-and-cloudfront.config.sql

	mysql \
	-u ${WORDPRESS_DB_USER} \
	-D ${WORDPRESS_DB_NAME} \
	--password=${WORDPRESS_DB_PASSWORD} \
	-h ${WORDPRESS_DB_HOST} \
	-v \
	-e 'source ./amazon-s3-and-cloudfront.config.sql'
}

init &

docker-entrypoint.sh apache2-foreground
