#
server {
   listen [::]:443 ssl http2;
   listen 443 ssl http2;

   # listen on the base host
   server_name example.com;

   # ssl configuration
   include conf.d/ssl/ssl.conf;
   ssl_certificate /etc/nginx/certificates/example.com.crt;
   ssl_certificate_key /etc/nginx/certificates/example.com.key;
   ssl_trusted_certificate /etc/nginx/certificates/bundle.pem;

   # and redirect to the www host (declared below)
   return 301 https://www.example.com$request_uri;

   # custom logs
   access_log /var/log/nginx/example.com.access.log;
   error_log /var/log/nginx/example.com.error.log;
}

#
server {
   listen [::]:443 ssl http2;
   listen 443 ssl http2;

   # the host name to respond to
   server_name www.example.com;

   # ssl configuration
   include conf.d/ssl/ssl.conf;
   ssl_certificate /etc/nginx/certificates/example.com.crt;
   ssl_certificate_key /etc/nginx/certificates/example.com.key;
   ssl_trusted_certificate /etc/nginx/certificates/bundle.pem;

   # path for static files
   root /var/www/example.com/html;

   # specify a charset
   charset utf-8;

   # custom logs
   access_log /var/log/nginx/example.com.access.log;
   error_log /var/log/nginx/example.com.error.log;

   include conf.d/common.conf;
}
