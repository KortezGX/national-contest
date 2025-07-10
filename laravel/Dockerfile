FROM ubuntu:22.04

LABEL maintainer="Laravel Development Environment"

# 避免交互式問題
ENV DEBIAN_FRONTEND=noninteractive
# 設定時區為台北
ENV TZ=Asia/Taipei

# 安裝必要套件及 PHP 8.2 laravel 開發環境
RUN apt-get update && \
    apt-get install -y \
    curl \
    software-properties-common \
    apt-transport-https \
    ca-certificates && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
    php8.2-fpm \
    php8.2-cli \
    php8.2-common \
    php8.2-mysql \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-xml \
    php8.2-bcmath \
    php8.2-pdo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 配置 PHP CLI & PHP-FPM 並配置 PHP-FPM 監聽端口和用戶
RUN sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php/8.2/cli/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/8.2/cli/php.ini && \
    sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/8.2/fpm/php.ini && \
    mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/user = www-data/user = node/g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/group = www-data/group = node/g' /etc/php/8.2/fpm/pool.d/www.conf

# 安裝 Composer 並設置版本 v2.8.9
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.8.9 && \
    composer --version

# 創建 node 用戶和群組並設置權限
RUN groupadd --gid 1000 node && \
    useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# 設置工作目錄
WORKDIR /var/www/html

# 暴露端口
EXPOSE 9000

# 啟動 PHP-FPM
CMD ["php-fpm8.2", "-F"]
