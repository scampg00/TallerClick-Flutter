"""Export TallerClick's editable vector mark and launcher icons.

Optional development tool: Python with Pillow. No Flutter dependency is added.
"""

import json
from pathlib import Path
from xml.sax.saxutils import quoteattr

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
NAVY = "#123A4A"
WHITE = "#FFFFFF"
# Shapes share a 108-unit canvas; the inset keeps the mark within adaptive masks.
SHAPES = [
    ("polygon", [(36, 33), (70, 33), (80, 48), (29, 48)], WHITE),
    ("rect", (25, 46, 83, 69, 6), WHITE),
    ("polygon", [(39, 38), (67, 38), (72, 46), (34, 46)], NAVY),
    ("rect", (29, 64, 39, 76, 3), WHITE),
    ("rect", (69, 64, 79, 76, 3), WHITE),
    ("circle", (34, 55, 3), NAVY),
    ("circle", (74, 55, 3), NAVY),
    ("rect", (43, 54, 65, 59, 2), NAVY),
    ("circle", (77, 72, 14), NAVY),
    ("circle", (77, 72, 11.5), WHITE),
    ("line", [(71, 72), (75, 76), (83, 67)], NAVY),
]


def vector_path(kind, points):
    if kind in ("polygon", "line"):
        return "M" + " L".join(f"{x},{y}" for x, y in points) + (
            " Z" if kind == "polygon" else ""
        )
    if kind == "circle":
        x, y, r = points
        return f"M{x-r},{y} a{r},{r} 0,1,0 {2*r},0 a{r},{r} 0,1,0 {-2*r},0"
    x, y, right, bottom, r = points
    return (
        f"M{x+r},{y} H{right-r} Q{right},{y} {right},{y+r} "
        f"V{bottom-r} Q{right},{bottom} {right-r},{bottom} "
        f"H{x+r} Q{x},{bottom} {x},{bottom-r} "
        f"V{y+r} Q{x},{y} {x+r},{y} Z"
    )


def write_vector_sources():
    branding = ROOT / "assets/branding"
    branding.mkdir(parents=True, exist_ok=True)
    svg = [
        '<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 108 108">',
        '<title>TallerClick: coche con una marca de confirmación</title>',
        f'<rect width="108" height="108" fill="{NAVY}"/>',
        '<g transform="translate(54 54) scale(.86) translate(-54 -54)">',
    ]
    android = [
        '<vector xmlns:android="http://schemas.android.com/apk/res/android"',
        ' android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">',
        '<group android:pivotX="54" android:pivotY="54" android:scaleX="0.86" android:scaleY="0.86">',
    ]
    for kind, geometry, color in SHAPES:
        path = quoteattr(vector_path(kind, geometry))
        if kind == "line":
            svg.append(f'<path d={path} fill="none" stroke="{color}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>')
            android.append(f'<path android:pathData={path} android:fillColor="@android:color/transparent" android:strokeColor="{color}" android:strokeWidth="4" android:strokeLineCap="round" android:strokeLineJoin="round"/>')
        else:
            svg.append(f'<path d={path} fill="{color}"/>')
            android.append(f'<path android:pathData={path} android:fillColor="{color}"/>')
    svg.append('</g></svg>')
    android.append('</group></vector>')
    (branding / "tallerclick.svg").write_text("\n".join(svg) + "\n", encoding="utf-8")
    resources = ROOT / "android/app/src/main/res"
    (resources / "drawable/ic_launcher_foreground.xml").write_text("\n".join(android) + "\n", encoding="utf-8")
    (resources / "values/ic_launcher_background.xml").write_text(
        f'<resources><color name="ic_launcher_background">{NAVY}</color></resources>\n', encoding="utf-8"
    )
    adaptive = resources / "mipmap-anydpi-v26"
    adaptive.mkdir(exist_ok=True)
    (adaptive / "ic_launcher.xml").write_text(
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '  <background android:drawable="@color/ic_launcher_background"/>\n'
        '  <foreground android:drawable="@drawable/ic_launcher_foreground"/>\n'
        '</adaptive-icon>\n', encoding="utf-8"
    )


def render(size):
    factor = size * 4 / 108
    image = Image.new("RGB", (size * 4, size * 4), NAVY)
    draw = ImageDraw.Draw(image)

    def coordinate(value):
        return ((value - 54) * .86 + 54) * factor

    for kind, geometry, color in SHAPES:
        if kind == "rect":
            x, y, right, bottom, radius = geometry
            draw.rounded_rectangle(
                (coordinate(x), coordinate(y), coordinate(right), coordinate(bottom)),
                radius=radius * .86 * factor, fill=color,
            )
        elif kind == "circle":
            x, y, r = geometry
            draw.ellipse((coordinate(x-r), coordinate(y-r), coordinate(x+r), coordinate(y+r)), fill=color)
        else:
            points = [(coordinate(x), coordinate(y)) for x, y in geometry]
            if kind == "polygon":
                draw.polygon(points, fill=color)
            else:
                width = round(4 * .86 * factor)
                draw.line(points, fill=color, width=width, joint="curve")
                for x, y in points:
                    r = width / 2
                    draw.ellipse((x-r, y-r, x+r, y+r), fill=color)
    return image.resize((size, size), Image.Resampling.LANCZOS)


def main():
    write_vector_sources()
    render(1024).save(ROOT / "assets/branding/tallerclick.png")
    resources = ROOT / "android/app/src/main/res"
    for density, size in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        render(size).save(resources / f"mipmap-{density}/ic_launcher.png")
    ios = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((ios / "Contents.json").read_text(encoding="utf-8"))
    for item in contents["images"]:
        size = round(float(item["size"].split("x")[0]) * float(item["scale"].rstrip("x")))
        render(size).save(ios / item["filename"])
    print("Iconos TallerClick exportados para Android e iOS.")


if __name__ == "__main__":
    main()
