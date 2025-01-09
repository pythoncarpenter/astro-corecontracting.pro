# requirements:
#   pip install Pillow
#
# usage:
#   python template_image.py

import os
import random
from PIL import Image, ImageDraw, ImageFont

def generate_top_images(output_dir="placeholder_images_top", count=10):
    """
    Generate `count` faux images (800x600) with random background colors,
    each labeled as 'Top #', and saved as Top#.png

    :param output_dir: Directory to save the images
    :param count: Number of images to generate
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Try loading a default TrueType font. Otherwise, Pillow will fall back
    # to a built-in font. If you want a specific font, provide a path.
    # For example on many systems, a default TTF might be located at:
    # /Library/Fonts/Arial.ttf (Mac), or
    # C:\Windows\Fonts\Arial.ttf (Windows)
    try:
        font = ImageFont.truetype("arial.ttf", 48)
    except IOError:
        # Fallback: use the default PIL font
        font = ImageFont.load_default()

    width, height = 800, 600

    for i in range(1, count + 1):
        # Pick a random background color in RGB format
        bg_color = (
            random.randint(0, 255),
            random.randint(0, 255),
            random.randint(0, 255),
        )

        # Create the image
        img = Image.new('RGB', (width, height), color=bg_color)
        draw = ImageDraw.Draw(img)

        text = f"Top {i}"

        # textbbox returns the bounding box of the text
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]

        # Calculate text position to center it
        x = (width - text_width) / 2
        y = (height - text_height) / 2

        # Choose a text color that is visible against the background
        text_color = (255, 255, 255) if sum(bg_color) < 300 else (0, 0, 0)

        # Draw the text onto the image
        draw.text((x, y), text, font=font, fill=text_color)

        # Save image as 'Top1.png', 'Top2.png', etc.
        filename = f"Top{i}.png"
        img.save(os.path.join(output_dir, filename))
        print(f"Generated {filename} with background color {bg_color}")


if __name__ == "__main__":
    generate_top_images()