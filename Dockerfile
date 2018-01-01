FROM ymd7/centos7-ruby:2.4.1

ENV APP_ROOT /usr/src/app

WORKDIR $APP_ROOT

RUN \
  yum -y update && \
  yum -y install epel-release

###
#  CentOS 7.4 がリリースされるまでの
#  nodejs に必要な http-parser の問題回避
###
RUN \
  rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm && \
  wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo

RUN \
  yum -y install nodejs yarn sqlite-devel postgresql-devel && \
  yum -y install libjpeg-devel libpng-devel && \
  yum -y install ImageMagick ImageMagick-devel

COPY Gemfile      $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'install: --no-document' >> ~/.gemrc && \
  echo 'update: --no-document' >> ~/.gemrc && \
  gem install nokogiri && \
  bundle config --global jobs 4 && \
  bundle install && \
  rbenv rehash
