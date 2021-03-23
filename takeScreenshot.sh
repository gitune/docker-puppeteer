#!/bin/bash
if [ $# -lt 2 ]; then
  echo "usage: $0 [URL] [FILENAME]"
  exit 1
fi

js_script=`cat <<EOT
const puppeteer = require('puppeteer');

// constants
const DL_PATH='/home/node/Downloads';

async function scrollToBottom(page, viewportHeight) {
  const getScrollHeight = () => {
    return Promise.resolve(document.documentElement.scrollHeight)
  };

  let scrollHeight = await page.evaluate(getScrollHeight);
  let currentPosition = 0;

  while (currentPosition < scrollHeight) {

    const nextPosition = currentPosition + viewportHeight;

    await page.evaluate(function (scrollTo) {
        return Promise.resolve(window.scrollTo(0, scrollTo))
      }, nextPosition);

    currentPosition = nextPosition;
    console.log("currentPosition: " + currentPosition);

    // stop reevaluating scrollHeight when scrolling down
    //scrollHeight = await page.evaluate(getScrollHeight);
    console.log("scrollHeight: " + scrollHeight);
  }
}

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'google-chrome-stable',
    userDataDir: '/home/node/.config/google-chrome',
    headless: true,
    args: [
      '--lang=ja,en-US,en',
      '--disable-dev-shm-usage',
      '--unhandled-rejections=strict'
    ]
  });
  const viewportHeight = 768;
  const page = await browser.newPage();
  await page.setViewport({width: 1024, height: viewportHeight, deviceScaleFactor: 1.5});
  await page.setExtraHTTPHeaders({
    'Accept-Language': 'ja,en-US;q=0.8,en;q=0.6'
  });

  // set URL
  const url = '${1}';
  await page.goto(url, {waitUntil: ['load', 'networkidle2'], timeout: 60000})
    .catch(e => console.log('timeout exceed. proceed to next operation'));

  await scrollToBottom(page, viewportHeight);
  await page.screenshot({path: DL_PATH + '/${2}', type: 'jpeg', fullPage: true});

  console.log("save screenshot: " + url + " to ${2}");
  await browser.close();
})();
EOT
`

docker run -i --init --rm --cap-add=SYS_ADMIN \
    -v ${HOME}/var/docker/docker-puppeteer/home:/home/node \
    --name puppeteer-chrome puppeteer-chrome-linux \
    node -e "${js_script}"

# backup
#    xvfb-run -a --server-args="-screen 0 1280x800x24 -ac -nolisten tcp -dpi 96 +extension RANDR" \
