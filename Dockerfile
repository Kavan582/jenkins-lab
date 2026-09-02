FROM nginx:alpine



RUN apk update && \

    apk upgrade --no-cache && \

    apk add --no-cache --upgrade expat



COPY index.html /usr/share/nginx/html/index.html
