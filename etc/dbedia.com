server {
    server_name  .dbedia.com;

    access_log /var/log/nginx/dbedia-access.log;

    include /etc/dbedia/sites-enabled/*;
}
