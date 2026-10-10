"""Export localized iOS and Android decks. Requires Playwright and Pillow."""
import argparse
import asyncio
import json
import os
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from PIL import Image, ImageOps, ImageDraw
from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parents[1]
DECKS = [('iphone',1320,2868),('ipad',2064,2752),('android',1080,1920),('feature-graphic',1024,500)]
CREATIVES = [('header',3840,1646,'header'),('search',3840,2560,'search-results')]
EXTRA_SIZES = {'iphone':[(1284,2778),(1206,2622),(1125,2436)], 'ipad':[(2048,2732)], 'android':[], 'feature-graphic':[]}


def deck_root(device):
    if device == 'feature-graphic':
        return ROOT / 'export/android/feature-graphic'
    return ROOT / 'export' / ('android/phone' if device == 'android' else f'apple/{device}')


async def main(device_filter=None, locale_filter=None, creatives_only=False):
    assert not creatives_only or device_filter is None, '--creatives-only cannot be combined with --device'
    state = json.loads((ROOT / 'app-store-screenshots.json').read_text())
    locales = locale_filter or state['locales']
    assert set(locales) <= set(state['locales']), 'Unknown locale'
    decks = [] if creatives_only else [d for d in DECKS if device_filter is None or d[0] == device_filter]
    creatives = CREATIVES if device_filter is None else []
    base = os.environ.get('BASE', 'http://localhost:3020')
    semaphore = asyncio.Semaphore(3)
    async with async_playwright() as p:
        browser = await p.chromium.launch(executable_path=os.environ.get('CHROME', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'), headless=True)

        async def render(device, w, h, locale):
            async with semaphore:
                page = await browser.new_page(viewport={'width':w,'height':h}, device_scale_factor=1)
                errors = []
                page.on('pageerror', lambda error: errors.append(str(error)))
                try:
                    for i, slide in enumerate(state['slidesByDevice'][device]):
                        await page.goto(f'{base}/preview?device={device}&locale={locale}&bare&from={i}&n=1', wait_until='networkidle')
                        await page.evaluate('document.fonts.ready')
                        await page.wait_for_function('() => document.images.length > 0 && [...document.images].every(i => i.complete && i.naturalWidth > 0)')
                        await page.wait_for_function("() => [...document.querySelectorAll('[data-placeholder]')].some(e => e.textContent.trim().length > 0)")
                        assert not errors, errors
                        text_errors = await page.evaluate("""() => {
                            const boxes = [...document.querySelectorAll('[data-placeholder]')].filter(e => e.textContent.trim()).map(e => {
                                const range = document.createRange(); range.selectNodeContents(e);
                                return {text:e.textContent, rect:range.getBoundingClientRect()};
                            });
                            const errors = [];
                            for (let i=0;i<boxes.length;i++) {
                                const {text,rect:a}=boxes[i];
                                if(a.left < -2 || a.right > innerWidth+2 || a.top < -2 || a.bottom > innerHeight+2) errors.push('Clipped: '+text);
                                for(let j=i+1;j<boxes.length;j++) {
                                    const b=boxes[j].rect;
                                    if(Math.min(a.right,b.right)-Math.max(a.left,b.left)>2 && Math.min(a.bottom,b.bottom)-Math.max(a.top,b.top)>2) errors.push('Overlap: '+text+' / '+boxes[j].text);
                                }
                            }
                            return errors;
                        }""")
                        assert not text_errors, (device, locale, i+1, text_errors)
                        path = deck_root(device) / f'{w}x{h}' / locale / f'{i+1:02d}.png'
                        path.parent.mkdir(parents=True, exist_ok=True)
                        await page.screenshot(path=str(path), animations='disabled')
                        with Image.open(path) as image:
                            assert image.size == (w,h)
                            assert image.getextrema()[0][0] != image.getextrema()[0][1], f'Blank: {path}'
                            image.convert('RGB').save(path)
                    print(f'Rendered {device}/{locale}: {len(state["slidesByDevice"][device])} slides', flush=True)
                finally:
                    await page.close()
        async def render_creative(kind, w, h, folder, locale):
            async with semaphore:
                page = await browser.new_page(viewport={'width':w,'height':h}, device_scale_factor=1)
                errors = []
                page.on('pageerror', lambda e: errors.append(str(e)))
                try:
                    await page.goto(f'{base}/creative?kind={kind}&locale={locale}', wait_until='networkidle')
                    await page.wait_for_function('() => document.images.length > 0 && [...document.images].every(i => i.complete && i.naturalWidth > 0)')
                    await page.evaluate('document.fonts.ready')
                    await page.wait_for_timeout(100)
                    assert not errors, errors
                    overflow = await page.evaluate("""() => [...document.querySelectorAll('[data-placeholder]')].flatMap(el => {
                        const range=document.createRange(); range.selectNodeContents(el);
                        const b=el.getBoundingClientRect();
                        return [...range.getClientRects()].some(r=>r.left<b.left-2 || r.right>b.right+2 || r.top<0 || r.bottom>innerHeight)
                            ? [el.textContent] : [];
                    })""")
                    assert not overflow, (kind, locale, overflow)
                    if kind == 'search':
                        overlap = await page.evaluate("""() => {
                            const top=Math.min(...[...document.querySelectorAll('[data-phone]')].map(e=>e.getBoundingClientRect().top));
                            return [...document.querySelectorAll('[data-placeholder]')].some(el=>{
                                const r=document.createRange(); r.selectNodeContents(el);
                                return r.getBoundingClientRect().bottom>top-20;
                            });
                        }""")
                        assert not overlap, (kind, locale, 'Text overlaps phone')
                    path=ROOT/'export/apple'/folder/locale/'01.png'
                    path.parent.mkdir(parents=True,exist_ok=True)
                    await page.screenshot(path=str(path),animations='disabled')
                    with Image.open(path) as image:
                        assert image.size==(w,h)
                        assert any(a!=b for a,b in image.getextrema()),path
                        image.convert('RGB').save(path)
                    print(f'Rendered {folder}/{locale}',flush=True)
                finally:
                    await page.close()
        try:
            await asyncio.gather(*(render(device,w,h,locale) for locale in locales for device,w,h in decks))
            await asyncio.gather(*(render_creative(kind,w,h,folder,locale) for locale in locales for kind,w,h,folder in creatives))
        finally:
            await browser.close()
    files = []
    for locale in locales:
        locale_files = []
        for device,w,h in decks:
            original = deck_root(device) / f'{w}x{h}' / locale
            originals = sorted(original.glob('*.png'))
            assert len(originals) == len(state['slidesByDevice'][device])
            for sw,sh in EXTRA_SIZES[device]:
                dest = deck_root(device) / f'{sw}x{sh}' / locale
                dest.mkdir(parents=True,exist_ok=True)
                for path in originals:
                    with Image.open(path) as image:
                        ImageOps.fit(image,(sw,sh),method=Image.Resampling.LANCZOS).save(dest / path.name)
            deck_files = [p for size in [(w,h)]+EXTRA_SIZES[device] for p in sorted((deck_root(device) / f'{size[0]}x{size[1]}' / locale).glob('*.png'))]
            assert len(deck_files) == len(originals)*(1+len(EXTRA_SIZES[device]))
            locale_files.extend(deck_files)
            thumb_w,thumb_h = 264,round(264*h/w)
            contact = Image.new('RGB',(thumb_w*len(originals),thumb_h),'#F1F2F0')
            for i,path in enumerate(originals):
                with Image.open(path) as image:
                    contact.paste(image.resize((thumb_w,thumb_h),Image.Resampling.LANCZOS),(i*thumb_w,0))
            name='preview' if device=='iphone' else f'preview-{device}'
            contact.save(ROOT / 'export' / f'{name}{"" if locale=="en" else "-"+locale}.jpg',quality=95)
        for kind,w,h,folder in creatives:
            path=ROOT/'export/apple'/folder/locale/'01.png'
            with Image.open(path) as image:
                assert image.mode=='RGB' and image.size==(w,h),path
            locale_files.append(path)
        if creatives_only:
            locale_files += sorted((ROOT/'export/apple/iphone').glob(f'*/{locale}/*.png'))
            locale_files += sorted((ROOT/'export/apple/ipad').glob(f'*/{locale}/*.png'))
            locale_files += sorted((ROOT/'export/android/phone').glob(f'*/{locale}/*.png'))
            locale_files += sorted((ROOT/'export/android/feature-graphic').glob(f'*/{locale}/*.png'))
        for path in locale_files:
            with Image.open(path) as image:
                assert image.mode=='RGB'
                if 'x' in path.parent.parent.name:
                    assert image.size==tuple(map(int,path.parent.parent.name.split('x')))
        with ZipFile(ROOT / 'export' / f'pegma-{device_filter or "all"}-{locale}.zip','w',ZIP_DEFLATED) as archive:
            for path in locale_files:
                archive.write(path,path.relative_to(ROOT / 'export'))
        files.extend(locale_files)
    with ZipFile(ROOT / 'export' / f'pegma-{device_filter or "all"}-localized.zip','w',ZIP_DEFLATED) as archive:
        for path in files:
            archive.write(path,path.relative_to(ROOT / 'export'))
    print(f'Checked {len(files)} PNGs: dimensions, RGB, nonblank, text bounds.',flush=True)
    for kind,w,h,folder in creatives:
        tw,th=480,round(480*h/w)
        gallery=Image.new('RGB',(tw*4,(th+32)*((len(locales)+3)//4)),'#F1F2F0')
        draw=ImageDraw.Draw(gallery)
        for i,locale in enumerate(locales):
            x,y=(i%4)*tw,(i//4)*(th+32)
            draw.text((x+12,y+10),locale.upper(),fill='#3F3F3F')
            with Image.open(ROOT/'export/apple'/folder/locale/'01.png') as im:
                gallery.paste(im.resize((tw,th),Image.Resampling.LANCZOS),(x,y+32))
        gallery.save(ROOT/'export'/f'preview-apple-{folder}.jpg',quality=95)
    if device_filter is None or device_filter=='iphone':
        tw,th=264,574
        gallery=Image.new('RGB',(tw*4,(th+32)*((len(locales)+3)//4)),'#F1F2F0')
        draw=ImageDraw.Draw(gallery)
        for i,locale in enumerate(locales):
            x,y=(i%4)*tw,(i//4)*(th+32)
            draw.text((x+12,y+10),locale.upper(),fill='#3F3F3F')
            with Image.open(deck_root('iphone')/'1320x2868'/locale/'01.png') as im:
                gallery.paste(im.resize((tw,th),Image.Resampling.LANCZOS),(x,y+32))
        gallery.save(ROOT/'export/preview-locales.jpg',quality=95)


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--device',choices=['iphone','ipad','android','feature-graphic'])
    parser.add_argument('--locales',nargs='+')
    parser.add_argument('--creatives-only',action='store_true',help='Export Apple Header / Search Results, reuse existing device PNGs in ZIPs')
    args=parser.parse_args()
    asyncio.run(main(args.device,args.locales,args.creatives_only))
