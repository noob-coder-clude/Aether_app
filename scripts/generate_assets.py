import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

def create_aether_logo(size=512):
    img = Image.new('RGBA', (size, size), (11, 14, 20, 255))
    draw = ImageDraw.Draw(img)
    center = size // 2

    # Draw outer glowing ring
    for radius in range(center - 40, center - 110, -2):
        alpha = int(180 * (1 - abs(radius - (center - 75)) / 35))
        if alpha > 0:
            color = (0, 229, 255, alpha) if radius > center - 75 else (124, 77, 255, alpha)
            draw.ellipse([center - radius, center - radius, center + radius, center + radius], outline=color, width=3)

    # Core geometric ring
    draw.ellipse([center - 160, center - 160, center + 160, center + 160], outline=(0, 229, 255, 255), width=18)
    draw.ellipse([center - 120, center - 120, center + 120, center + 120], outline=(124, 77, 255, 255), width=12)

    # Tunnel stylized 'A' & infinity loop
    draw.line([(center, center - 110), (center - 70, center + 70)], fill=(0, 229, 255, 255), width=16)
    draw.line([(center, center - 110), (center + 70, center + 70)], fill=(255, 0, 127, 255), width=16)
    draw.line([(center - 45, center + 20), (center + 45, center + 20)], fill=(124, 77, 255, 255), width=14)

    # Glowing core dot
    draw.ellipse([center - 20, center - 20, center + 20, center + 20], fill=(0, 229, 255, 255))

    return img

os.makedirs('assets/logo', exist_ok=True)
logo = create_aether_logo(512)
logo.save('assets/logo/aether_logo.png')

# Generate mipmap icons for Android
mipmap_dirs = {
    'android/app/src/main/res/mipmap-mdpi': 48,
    'android/app/src/main/res/mipmap-hdpi': 72,
    'android/app/src/main/res/mipmap-xhdpi': 96,
    'android/app/src/main/res/mipmap-xxhdpi': 144,
    'android/app/src/main/res/mipmap-xxxhdpi': 192,
}

for path, icon_size in mipmap_dirs.items():
    os.makedirs(path, exist_ok=True)
    icon = logo.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
    icon.save(os.path.join(path, 'ic_launcher.png'))
    icon.save(os.path.join(path, 'ic_launcher_round.png'))

print("Assets successfully generated.")
