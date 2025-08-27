import asyncio
from pyppeteer import launch

async def main():
    browser = await launch(headless=True, args=['--no-sandbox'])
    page = await browser.newPage()
    await page.goto('https://example.com')
    print(await page.content()[:500])
    await browser.close()

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
