FROM nginx

COPY css/. /usr/share/nginx/html/css
COPY fonts/. /usr/share/nginx/html/fonts
COPY images/. /usr/share/nginx/html/images
COPY scripts/. /usr/share/nginx/html/scripts
COPY webjars/. /usr/share/nginx/html/webjars
COPY index.html /usr/share/nginx/html/index.html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY run.sh /run.sh

RUN chmod 777 run.sh

ENTRYPOINT [ "./run.sh" ]