from PIL import Image
import os

for x in range(4):
    for y in range(2):
        path = f'assets/images/cell_{x}_{y}.jpg'
        img = Image.open(path)
        img = img.resize((1, 1))
        color = img.getpixel((0, 0))
        print(f"Cell {x},{y}: Avg Color {color}")
