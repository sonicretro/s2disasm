using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.S2LVL;

namespace S2ObjectDefinitions.Common
{
    class PathSwapper : ObjectDefinition
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
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Ring.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj03.bin");
            img = ObjectHelper.MapToBmp(artfile, mapfile, 0, 1, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < 8; i++)
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
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7 });
        }

        public override string Name()
        {
            return "Path Swapper";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            string result = (subtype & 4) == 4 ? "Horizontal" : "Vertical";
            return result;
        }

        public override string FullName(byte subtype)
        {
            return Name() + " - " + SubtypeName(subtype);
        }

        public override BitmapBits Image()
        {
            return img;
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[subtype & 7];
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[subtype & 7].X, loc.Y + offsets[subtype & 7].Y, imgws[subtype & 7], imghs[subtype & 7]);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (!includeDebug) return;
            BitmapBits bits = new BitmapBits(imgs[subtype & 7]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype & 7].X, loc.Y + offsets[subtype & 7].Y));
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(PathSwapperS2ObjectEntry);
            }
        }
    }

    public class PathSwapperS2ObjectEntry : S2ObjectEntry
    {
        public PathSwapperS2ObjectEntry() : base() { }
        public PathSwapperS2ObjectEntry(byte[] file, int address) : base(file, address) { }

        [DisplayName("Size")]
        public byte size
        {
            get
            {
                return (byte)(SubType & 3);
            }
            set
            {
                SubType = (byte)((SubType & ~3) | (value & 3));
            }
        }

        public Direction Direction
        {
            get
            {
                return (SubType & 4) == 4 ? Direction.Horizontal : Direction.Vertical;
            }
            set
            {
                SubType = (byte)((SubType & ~4) | (value  == Direction.Horizontal ? 4 : 0));
            }
        }

        [DisplayName("Right/Down Path")]
        public byte RDPath
        {
            get
            {
                return (byte)((SubType & 8) == 8 ? 1 : 0);
            }
            set
            {
                SubType = (byte)((SubType & ~8) | ((value & 1) * 8));
            }
        }

        [DisplayName("Left/Up Path")]
        public byte LUPath
        {
            get
            {
                return (byte)((SubType & 16) == 16 ? 1 : 0);
            }
            set
            {
                SubType = (byte)((SubType & ~16) | ((value & 1) * 16));
            }
        }

        [DisplayName("Right/Down Plane")]
        public byte RDPlane
        {
            get
            {
                return (byte)((SubType & 32) == 32 ? 1 : 0);
            }
            set
            {
                SubType = (byte)((SubType & ~32) | ((value & 1) * 32));
            }
        }

        [DisplayName("Left/Up Plane")]
        public byte LUPlane
        {
            get
            {
                return (byte)((SubType & 64) == 64 ? 1 : 0);
            }
            set
            {
                SubType = (byte)((SubType & ~64) | ((value & 1) * 64));
            }
        }
    }
}
