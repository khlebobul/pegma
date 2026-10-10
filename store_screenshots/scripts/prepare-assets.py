"""Restore local editor assets from the app and installed screenshot template."""
from pathlib import Path
import shutil

editor = Path(__file__).resolve().parents[1]
app = editor.parent
template = Path.home() / '.agents/skills/app-store-screenshots/template'
for source, relative in [
    (app / 'assets/fonts/pegma-app.ttf', 'fonts/pegma-app.ttf'),
    (app / 'assets/logo/logo-light.png', 'app-icon.png'),
    (template / 'public/mockup.png', 'mockup.png'),
]:
    destination = editor / 'public' / relative
    if not destination.exists():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, destination)
    assert destination.stat().st_size > 0, destination
print('Local editor assets ready.')
