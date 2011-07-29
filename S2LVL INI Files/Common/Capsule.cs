using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S2ObjectDefinitions.Common
{
    class Capsule : SonicRetro.SonLVL.ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Egg Prison.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj3E.bin");
            Point off;
            BitmapBits im;
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

        public override BitmapBits Image()
        {
            return imgs[0];
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[0];
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[0].X, loc.Y + offsets[0].Y - imghs[1], imgws[0], imghs[0] + imghs[1]);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            bmp.DrawBitmapComposited(imgs[0], new Point(loc.X + offsets[0].X, loc.Y + offsets[0].Y));
            bmp.DrawBitmapComposited(imgs[1], new Point(loc.X + offsets[1].X, loc.Y + offsets[0].Y - imghs[1]));
        }
    }
}
