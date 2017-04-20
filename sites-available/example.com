#
server {
   listen [::]:80;
   listen 80;

   # listen on the base host
   server_name example.com;

   # and redirect to the www host (declared below)
   return 301 $scheme://www.example.com$request_uri;

   # custom logs
   access_log /var/log/nginx/example.com.access.log;
   error_log /var/log/nginx/example.com.error.log;
}

#
server {
   listen [::]:80;
   listen 80;

   # the host name to respond to
   server_name www.example.com;

   # path for static files
   root /var/www/example.com/html;

   # specify a charset
   charset utf-8;

   # custom logs
   access_log /var/log/nginx/example.com.access.log;
   error_log /var/log/nginx/example.com.error.log;

   include conf.d/common.conf;
}
