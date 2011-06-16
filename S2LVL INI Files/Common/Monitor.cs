using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.Common
{
    class Monitor : SonicRetro.S2LVL.ObjectDefinition
    {
        private Point offset;
        private BitmapBits img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<BitmapBits> imgs = new List<BitmapBits>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            List<byte> tmpartfile = new List<byte>();
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("../art/nemesis/Monitor and contents.bin", Compression.CompressionType.Nemesis));
            tmpartfile.AddRange(new byte[0x2A80 - tmpartfile.Count]);
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("../art/nemesis/Sonic lives counter.bin", Compression.CompressionType.Nemesis));
            byte[] artfile = tmpartfile.ToArray();
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj26.bin");
            img = ObjectHelper.MapToBmp(artfile, mapfile, 1, 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < 11; i++)
            {
                im = ObjectHelper.MapToBmp(artfile, mapfile, i + 1, 0, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 });
        }

        public override string Name()
        {
            return "Monitor";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Static";
                case 1:
                    return "Sonic";
                case 2:
                    return "Tails";
                case 3:
                    return "Eggman";
                case 4:
                    return "Rings";
                case 5:
                    return "Shoes";
                case 6:
                    return "Shield";
                case 7:
                    return "Invincibility";
                case 8:
                    return "Teleport";
                case 9:
                    return "Random";
                case 10:
                    return "Broken";
                default:
                    return "Invalid";
            }
        }

        public override string FullName(byte subtype)
        {
            return SubtypeName(subtype) + " " + Name();
        }

        public override BitmapBits Image()
        {
            return img;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype <= 10)
                return imgs[subtype];
            else
                return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype <= 10)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (subtype > 10) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y));
        }
    }
}
