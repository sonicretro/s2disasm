using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.ARZ
{
    class Platform : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.LevelArt;
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj18_b.bin");
            Point off;
            Bitmap im;
            im = ObjectHelper.MapToBmp(artfile, mapfile, 0, 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 1, 2, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03, 0x9A });
        }

        public override string Name()
        {
            return "Platform";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return ((PlatformMovement)(subtype & 3)).ToString();
        }

        public override string FullName(byte subtype)
        {
            return Name() + " - " + SubtypeName(subtype);
        }

        public override Bitmap Image()
        {
            return imgs[0];
        }

        public override Bitmap Image(byte subtype)
        {
            return imgs[(subtype & 0x10) >> 4];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            gfx.DrawImageFlipped(imgs[(subtype & 0x10) >> 4], loc.X + offsets[(subtype & 0x10) >> 4].X, loc.Y + offsets[(subtype & 0x10) >> 4].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[(subtype & 0x10) >> 4].X, loc.Y + offsets[(subtype & 0x10) >> 4].Y, imgws[(subtype & 0x10) >> 4], imghs[(subtype & 0x10) >> 4]);
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(PlatformS2ObjectEntry);
            }
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }
    }

    public class PlatformS2ObjectEntry : S2ObjectEntry
    {
        public PlatformS2ObjectEntry() : base() { }
        public PlatformS2ObjectEntry(byte[] file, int address) : base(file, address) { }

        public PlatformMovement Movement
        {
            get
            {
                return (PlatformMovement)(SubType & 3);
            }
            set
            {
                SubType = (byte)((SubType & ~3) | (int)value);
            }
        }

        public ArtSize Art
        {
            get
            {
                return (ArtSize)((SubType & 0x10) >> 4);
            }
            set
            {
                SubType = (byte)((SubType & ~0x10) | ((int)value << 4));
            }
        }

        public Solid Solid
        {
            get
            {
                return (ARZ.Solid)((SubType & 0x80) >> 7);
            }
            set
            {
                SubType = (byte)((SubType & ~0x80) | ((int)value << 7));
            }
        }
    }

    public enum PlatformMovement
    {
        Stationary,
        Horizontal,
        Vertical,
        Falling
    }

    public enum ArtSize
    {
        Small,
        Large
    }

    public enum Solid
    {
        TopSolid,
        AllSolid
    }
}
