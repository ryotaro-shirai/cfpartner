# FROMでベースイメージを設定
# 今回はRubyのバージョン3.4をベースイメージとして設定
FROM ruby:3.4
# 必要なライブラリをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-mysql-client vim

# Railsアプリを配置するフォルダをコンテナ内に作成
RUN mkdir /app
# 作成したディレクトリをワークディレクトリとして設定
WORKDIR /app
# ルート配下のGemfileをコンテナ内のRailsアプリを配置場所にコピー
COPY Gemfile /app/Gemfile
# Gemfile.lockも同様にコンテナ内にコピーする
COPY Gemfile.lock /app/Gemfile.lock
# Gemfileの記述を元にbundle installを実行
RUN bundle install --gemfile /app/Gemfile
COPY . /app

# ローカルで作成したentrypoint.shファイル(後で記述)を/usr/bin/へコピー
COPY entrypoint.sh /usr/bin/
# /usr/bin/entrypoint.shに対して実行権限を付与している(chmod +x)
# これによってシェルスクリプトファイルを実行可能にする
RUN chmod +x /usr/bin/entrypoint.sh
# exec形式でデフォルトで実行するコマンドラインの引数としてentrypoint.shを指定
ENTRYPOINT ["entrypoint.sh"]
# ネットワーク上のポートを指定する
EXPOSE 3000

# Railsサーバーを稼働させる
CMD ["rails", "server", "-b", "0.0.0.0"]