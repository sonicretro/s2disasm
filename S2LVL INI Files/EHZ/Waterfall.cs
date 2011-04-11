using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.EHZ
{
    class Waterfall : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Waterfall tiles.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj49.bin");
            Point off;
            Bitmap im;
            im = ObjectHelper.MapToBmp(artfile, mapfile, 1, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.UnknownObject(out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 3, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.UnknownObject(out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 5, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 6, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x02, 0x04, 0x05 });
        }

        public override string Name()
        {
            return "Waterfall";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return string.Empty;
        }

        public override string FullName(byte subtype)
        {
            return Name();
        }

        public override Bitmap Image()
        {
            return imgs[0];
        }

        public override Bitmap Image(byte subtype)
        {
            if (subtype > 5) return imgs[1];
            return imgs[subtype];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            if (subtype > 5)
                gfx.DrawImageFlipped(imgs[1], loc.X + offsets[1].X, loc.Y + offsets[1].Y, XFlip, YFlip);
            else
                gfx.DrawImageFlipped(imgs[subtype], loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype > 5) return new Rectangle(loc.X + offsets[1].X, loc.Y + offsets[1].Y, imgws[1], imghs[1]);
            return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }

        public override void DrawExport(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > 5) subtype = 1;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
        }
    }
}
