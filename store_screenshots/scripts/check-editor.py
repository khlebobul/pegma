"""Check the editor's real browser ZIP export without modifying project state."""
import asyncio
import argparse
import io
import json
import os
from pathlib import Path
from zipfile import ZipFile
from PIL import Image
from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parents[1]


async def main(device='android'):
    state = json.loads((ROOT / 'app-store-screenshots.json').read_text())
    state.update(device=device, locales=['en'], locale='en')
    expected_size = (1024, 500) if device == 'feature-graphic' else (1080, 1920)
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            executable_path=os.environ.get('CHROME', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'),
            headless=True)
        try:
            page = await browser.new_page(viewport={'width': 1600, 'height': 1000}, accept_downloads=True)
            errors = []
            page.on('pageerror', lambda error: errors.append(str(error)))

            async def project(route):
                await route.fulfill(json={'ok': True, 'state': state}
                                    if route.request.method == 'GET' else {'ok': True})

            await page.route('**/api/project', project)
            await page.goto(os.environ.get('BASE', 'http://localhost:3020'), wait_until='networkidle')
            button = page.get_by_role('button', name='Export bundle', exact=True)
            await button.wait_for()
            await page.evaluate('document.fonts.ready')
            (ROOT / 'reports').mkdir(exist_ok=True)
            await page.screenshot(path=str(ROOT / 'reports/editor.png'))
            async with page.expect_download(timeout=120000) as downloading:
                await button.click()
            download = await downloading.value
            dest = ROOT / 'reports/editor-export.zip'
            await download.save_as(str(dest))
            with ZipFile(dest) as archive:
                pngs = [name for name in archive.namelist() if name.endswith('.png')]
                assert len(pngs) == len(state['slidesByDevice'][device]), pngs
                for name in pngs:
                    with Image.open(io.BytesIO(archive.read(name))) as image:
                        assert image.size == expected_size, (name, image.size)
                        assert any(a != b for a, b in image.getextrema()), name
            assert not errors, errors
            print(f'Editor ZIP export passed: {len(pngs)} nonblank PNGs, {expected_size}, no JS errors; project untouched.')
        finally:
            await browser.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--device', choices=['android', 'feature-graphic'], default='android')
    asyncio.run(main(parser.parse_args().device))
