server {
    listen 80;
    server_name {{DOMAIN}};
    root {{ROOT}};
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location = /xmlrpc.php {
        deny all;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php{{PHP}}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
