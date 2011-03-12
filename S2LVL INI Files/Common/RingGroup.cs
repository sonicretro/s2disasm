using System;
using System.Collections.Generic;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.Common
{
    class RingGroup : S2RingDefinition
    {
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        private int spacing;

        public override void Init(Dictionary<string, string> data)
        {
            if (data.ContainsKey("art"))
            {
                byte[] artfile = ObjectHelper.OpenArtFile(data["art"], (Compression.CompressionType)Enum.Parse(typeof(Compression.CompressionType), data.GetValueOrDefault("artcmp", "Nemesis")));
                if (data.ContainsKey("map"))
                    img = ObjectHelper.MapToBmp(artfile, Compression.Decompress(data["map"], (Compression.CompressionType)Enum.Parse(typeof(Compression.CompressionType), data.GetValueOrDefault("mapcmp", "Uncompressed"))), int.Parse(data["frame"], System.Globalization.NumberStyles.Integer, System.Globalization.CultureInfo.InvariantCulture), int.Parse(data.GetValueOrDefault("pal", "0"), System.Globalization.NumberStyles.Integer, System.Globalization.CultureInfo.InvariantCulture), out offset);
                else if (data.ContainsKey("mapasm"))
                    img = ObjectHelper.MapASMToBmp(artfile, data["mapasm"], data["mapasmlbl"], int.Parse(data.GetValueOrDefault("pal", "0"), System.Globalization.NumberStyles.Integer, System.Globalization.CultureInfo.InvariantCulture), out offset);
            }
            imgw = img.Width;
            imgh = img.Height;
            spacing = int.Parse(data.GetValueOrDefault("spacing", "24"), System.Globalization.NumberStyles.Integer, System.Globalization.NumberFormatInfo.InvariantInfo);
        }

        public override string Name()
        {
            return "Rings";
        }

        public override Bitmap Image()
        {
            return img;
        }

        public override void Draw(Graphics gfx, Point loc, SonicRetro.S2LVL.Direction direction, byte count)
        {
            for (int i = 0; i < count; i++)
            {
                switch (direction)
                {
                    case SonicRetro.S2LVL.Direction.Horizontal:
                        gfx.DrawImage(img, loc.X + offset.X + (i * spacing), loc.Y + offset.Y, imgw, imgh);
                        break;
                    case SonicRetro.S2LVL.Direction.Vertical:
                        gfx.DrawImage(img, loc.X + offset.X, loc.Y + offset.Y + (i * spacing), imgw, imgh);
                        break;
                }
            }
        }

        public override System.Drawing.Rectangle Bounds(Point loc, Direction direction, byte count)
        {
            switch (direction)
            {
                case Direction.Horizontal:
                    return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, ((count - 1) * spacing) + imgw, imgh);
                case Direction.Vertical:
                    return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, ((count - 1) * spacing) + imgh);
            }
            return Rectangle.Empty;
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
        }
    }
}
