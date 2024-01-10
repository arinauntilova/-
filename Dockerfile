# Унтилова Арина ПУОР22-1м, лр_1
# 1) alpine - базовый образ
FROM alpine:latest
MAINTAINER Untilova Arina <untilovaao@mail.ru>
ENV TZ = Europe/Moscow
# 2) обновление apt-кэша; 3) обновление пакетов в контейнере
RUN apk update && apk upgrade && \
# 4) установка веб-сервера nginx
    apk add --no-cache nginx && \
# 5) очистка скачанного apt-cache
    rm -rf /var/cache/apk/* && \
# 6) удаление содержимого /var/www/ 
    rm -rf /var/www/* && \
# 7) создать в /var/www/ папку с именем сайта и папку с картинками 
    mkdir /var/www/untilova_project && \
	mkdir /var/www/untilova_project/img
# 8) поместить в /var/www/untilova_project index.html
COPY index.html /var/www/untilova_project
# 9) поместить в /var/www/untilova_project image.png
COPY image.png /var/www/untilova_project/img
# создание папок sites-available (конфигурации всех виртуальных хостов) 
# и sites-enabled (символические ссылки на активные)
RUN mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled
# установка нового файла конфигурации     
COPY default.conf /etc/nginx/sites-available/default
# чтобы активировать наш виртуальный хост, нужно создать символическую ссылку между sites-available, 
# где лежит наш файл конфигурации, и sites-enabled
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
# 10) задать владельцу права: читать, писать, исполнять (рекурсивно -R)
RUN chmod -R 755 /var/www/untilova_project && \
# 11) создать пользователя arina_unt (-D - без пароля)
    adduser -D -s /bin/false arina_unt && \
# 12) создать группу arina_untgroup
    addgroup arina_untgroup && \
# 13) поместить arina_unt в группу arina_untgroup
    adduser arina_unt arina_untgroup && \
# 14) присовить arina_unt и arina_untgroup на папку /var/www/untilova_project
    chown -R arina_unt:arina_untgroup /var/www/untilova_project
# 17) использовать sed для замены пользователя nginx 
RUN	sed -i 's/user www-data;/user arina_unt;/g' /etc/nginx/nginx.conf
# 21) задать команды запуска веб-сервера  
CMD  ["nginx", "-g", "daemon off;"]