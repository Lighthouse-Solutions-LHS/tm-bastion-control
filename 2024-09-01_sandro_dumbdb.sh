#!/bin/bash
mysqldump --skip-ssl -h tm-aws-db-restored-cluster.cluster-cytlgqqecfqj.eu-central-1.rds.amazonaws.com -u wordpress -pwordpress wordpress \
 --ignore-table=wordpress.wp_actionscheduler_logs \
 --ignore-table=wordpress.wp_aepc_logs \
 --ignore-table=wordpress.wp_borlabs_cookie_consent_log \
 --ignore-table=wordpress.wp_icwp_wpsf_at_logs \
 --ignore-table=wordpress.wp_icwp_wpsf_req_logs \
 --ignore-table=wordpress.wp_redirection_logs \
 --ignore-table=wordpress.wp_stock_log \
 --ignore-table=wordpress.wp_wc_download_log \
 --ignore-table=wordpress.wp_wfblockediplog \
 --ignore-table=wordpress.wp_wflogins \
 --ignore-table=wordpress.wp_woocommerce_log \
 --ignore-table=wordpress.wp_wpc_login_fails \
 --ignore-table=wordpress.wp_yith_ywrac_email_log \
 --ignore-table=wordpress.wp_cleverreach_wc_archive \
 --ignore-table=wordpress.wp_cleverreach_wc_automation \
 --ignore-table=wordpress.wp_cleverreach_wc_entity \
 --ignore-table=wordpress.wp_redirection_404 \
 --ignore-table=wordpress.wp_woocommerce_sessions \
> /var/lib/nginx/wordpress/2024-09-01_sync/2024-09-01_db.sql
