from PIL import Image
import os

os.makedirs('assets/images', exist_ok=True)
img_path = '/home/masihur/.gemini/antigravity/brain/554cf617-38ed-4a84-b0ac-0b4803a678f8/.user_uploaded/media_1790249110244.jpg'
img = Image.open(img_path)

# Save original as collage
img.save('assets/images/collage.jpg')

# We can crop the image into a 4x2 grid
w, h = img.size
cw = w // 4
ch = h // 2

# Top row
img.crop((0, 0, cw, ch)).save('assets/images/cell_0_0.jpg')
img.crop((cw, 0, 2*cw, ch)).save('assets/images/cell_1_0.jpg')
img.crop((2*cw, 0, 3*cw, ch)).save('assets/images/cell_2_0.jpg')
img.crop((3*cw, 0, w, ch)).save('assets/images/cell_3_0.jpg')

# Bottom row
img.crop((0, ch, cw, h)).save('assets/images/cell_0_1.jpg')
img.crop((cw, ch, 2*cw, h)).save('assets/images/cell_1_1.jpg')
img.crop((2*cw, ch, 3*cw, h)).save('assets/images/cell_2_1.jpg')
img.crop((3*cw, ch, w, h)).save('assets/images/cell_3_1.jpg')

print("Saved cells")
