using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.Common
{
    class Capsule : SonicRetro.S2LVL.ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Egg Prison.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj3E.bin");
            Point off;
            Bitmap im;
            im = ObjectHelper.MapToBmp(artfile, mapfile, 0, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 4, 1, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0 });
        }

        public override string Name()
        {
            return "Egg Prison";
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
            return imgs[0];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            gfx.DrawImage(imgs[0], loc.X + offsets[0].X, loc.Y + offsets[0].Y, imgws[0], imghs[0]);
            gfx.DrawImage(imgs[1], loc.X + offsets[1].X, loc.Y + offsets[0].Y - imghs[1], imgws[1], imghs[1]);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[0].X, loc.Y + offsets[0].Y - imghs[1], imgws[0], imghs[0] + imghs[1]);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            for (int i = 0; i < 2; i++)
                imgs[i].Palette = pal;
        }

        public override void DrawExport(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(imgs[0]);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[0].X, loc.Y + offsets[0].Y));
            bits = new BitmapBits(imgs[1]);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[1].X, loc.Y + offsets[0].Y - imghs[1]));
        }
    }
}