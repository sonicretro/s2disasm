using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.CPZ
{
    class Platform : ObjectDefinition
    {
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Large moving platform from CNZ.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj19.bin");
            Point off;
            Bitmap im;
            im = ObjectHelper.MapToBmp(artfile, mapfile, 0, 3, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapToBmp(artfile, mapfile, 1, 3, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            List<byte> types = new List<byte>();
            for (byte i = 0; i < 0x20; i++)
            {
                types.Add(i);
            }
            return new ReadOnlyCollection<byte>(types);
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
            return ((PlatformMovement)(subtype & 0xF)).ToString();
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

        public override void DrawExport(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(imgs[(subtype & 0x10) >> 4]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[(subtype & 0x10) >> 4].X, loc.Y + offsets[(subtype & 0x10) >> 4].Y));
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
                return (PlatformMovement)(SubType & 0xF);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF) | (int)value);
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
    }

    public enum PlatformMovement
    {
        Horizontal,
        Horizontal2,
        SlowVertical,
        MoveUpWhenSteppedOn,
        MoveUpAutomatically,
        Stationary,
        QuickVertical,
        QuickVertical2,
        Circle1,
        Circle2,
        Circle3,
        Circle4,
        ClockwiseCircle1,
        ClockwiseCircle2,
        ClockwiseCircle3,
        ClockwiseCircle4
    }

    public enum ArtSize
    {
        Large,
        Small
    }
}