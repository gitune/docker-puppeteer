# docker-puppeteer
Dockerfile for puppeteer and so on.

# これは何？

docker上でpuppeteerを使うためのDockerfileの一例とそちらを使ってweb pageのscreenshotを取るためのsh scriptです。基本的には[こちら](https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker)にある公式ドキュメントを参考にしました。

# 使い方

書くまでもないかもしれませんが💦

1. このリポジトリをcloneする
2. リポジトリトップで`docker build -t puppeteer-chrome-linux .`する
3. puppeteerで遊ぶ

てな感じです。お楽しみあれ。
