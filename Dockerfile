FROM alpine:3.4

MAINTAINER fehguy

RUN apk add --update nginx
RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/

# copy swagger files to the `/js` folder
COPY ./index.html /usr/share/nginx/html/
ADD ./dist/*.js /usr/share/nginx/html/dist/
ADD ./dist/*.map /usr/share/nginx/html/dist/
ADD ./dist/*.css /usr/share/nginx/html/dist/
ADD ./dist/*.png /usr/share/nginx/html/dist/
ADD ./docker-run.sh /usr/share/nginx/

EXPOSE 8080

CMD ["sh", "/usr/share/nginx/docker-run.sh"]

COPY uid_entrypoint /
RUN chmod +x /uid_entrypoint && \
    chgrp -R 0 /var/lib/nginx/ && \
    chmod -R g=u /run/nginx /var/lib/nginx/ /var/log/nginx && \
    chmod g=u /etc/passwd
ENTRYPOINT [ "/uid_entrypoint" ]
USER 1001

