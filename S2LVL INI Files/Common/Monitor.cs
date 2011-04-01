using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.Common
{
    class Monitor : SonicRetro.S2LVL.ObjectDefinition
    {
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
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
            Bitmap im;
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
                    return string.Empty;
            }
        }

        public override string FullName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Static Monitor";
                case 1:
                    return "Sonic Monitor";
                case 2:
                    return "Tails Monitor";
                case 3:
                    return "Eggman Monitor";
                case 4:
                    return "Rings Monitor";
                case 5:
                    return "Shoes Monitor";
                case 6:
                    return "Shield Monitor";
                case 7:
                    return "Invincibility Monitor";
                case 8:
                    return "Teleport Monitor";
                case 9:
                    return "Random Monitor";
                case 10:
                    return "Broken Monitor";
                default:
                    return "Monitor";
            }
        }

        public override Bitmap Image()
        {
            return img;
        }

        public override Bitmap Image(byte subtype)
        {
            if (subtype <= 10)
                return imgs[subtype];
            else
                return img;
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            if (subtype <= 10)
                gfx.DrawImageFlipped(imgs[subtype], loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, XFlip, YFlip);
            else
                gfx.DrawImageFlipped(img, loc.X + offset.X, loc.Y + offset.Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype <= 10)
                return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
            else
                return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
            for (int i = 0; i <= 10; i++)
                imgs[i].Palette = pal;
        }
    }
}