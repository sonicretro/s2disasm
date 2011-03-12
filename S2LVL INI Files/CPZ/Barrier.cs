using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using S2LVL;
using Extensions;
using System.Collections.ObjectModel;
using System.Drawing;

namespace S2ObjectDefinitions.CPZ
{
    class Barrier : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Stripy blocks from CPZ.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj2D.bin");
            Point off;
            Bitmap im;
            for (int i = 0; i < 4; i++)
            {
                im = ObjectHelper.MapToBmp(artfile, mapfile, i, 1, out off);
                imgs.Add(im);
                offsets.Add(off);
                imgws.Add(im.Width);
                imghs.Add(im.Height);                
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03 });
        }

        public override string Name()
        {
            return "One way barrier";
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
            if (subtype > 3) return imgs[0];
            return imgs[subtype];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            if (subtype > 3)
                gfx.DrawImageFlipped(imgs[0], loc.X + offsets[1].X, loc.Y + offsets[1].Y, true, true);
            else
                gfx.DrawImageFlipped(imgs[subtype], loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            if (subtype > 3) return new Rectangle(loc.X + offsets[0].X, loc.Y + offsets[0].Y, imgws[0], imghs[0]);
            return new Rectangle(loc.X + offsets[subtype].X, loc.Y + offsets[subtype].Y, imgws[subtype], imghs[subtype]);
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }
    }
}
