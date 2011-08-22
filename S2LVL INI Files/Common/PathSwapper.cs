using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL;

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
            List<byte> tmpartfile = new List<byte>();
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("Common/pathswapper-art.bin", Compression.CompressionType.Nemesis));
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj03.bin");
            byte[] artfile1 = tmpartfile.ToArray();
            img = ObjectHelper.MapToBmp(artfile1, mapfile, 0, 1, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            Point pos;
            Size delta;
            for (int i = 0; i < 32; i++)
            {
                byte[] artfile = tmpartfile.GetRange((i&0x18) << 5,256).ToArray();
                BitmapBits tempim = ObjectHelper.MapToBmp(artfile, mapfile, 0, 0, out off);
                if ((i&4) != 0)
                {
                    im = new BitmapBits(tempim.Width * (1 << (i&3)), tempim.Height);
                    delta = new Size(tempim.Width, 0);
                }
                else
                {
                    im = new BitmapBits(tempim.Width, tempim.Height * (1 << (i&3)));
                    delta = new Size(0, tempim.Height);
                }

                pos = new Point(0, 0);
                off = new Point(-(im.Width/2), -(im.Height/2));
                for (int j = 0; j < (1 << (i&3)); j++)
                {
                    im.DrawBitmap(tempim, pos);
                    pos = pos + delta;
                }
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
            return imgs[subtype & 0x1F];
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[subtype & 0x1F].X, loc.Y + offsets[subtype & 0x1F].Y, imgws[subtype & 0x1F], imghs[subtype & 0x1F]);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            if (!includeDebug) return;
            BitmapBits bits = new BitmapBits(imgs[subtype & 0x1F]);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[subtype & 0x1F].X, loc.Y + offsets[subtype & 0x1F].Y));
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

        [DisplayName("Priority only")]
        public override bool XFlip
        {
            get
            {
                return base.XFlip;
            }
            set
            {
                base.XFlip = value;
            }
        }

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
                return (SubType & 4) != 0 ? Direction.Horizontal : Direction.Vertical;
            }
            set
            {
                SubType = (byte)((SubType & ~4) | (value  == Direction.Horizontal ? 4 : 0));
            }
        }

        [DisplayName("Right/Down Path")]
        public bool RDPath
        {
            get
            {
                return (bool)((SubType & 8) != 0 ? true : false);
            }
            set
            {
                SubType = (byte)((SubType & ~8) | (value == true ? 8 : 0));
            }
        }

        [DisplayName("Left/Up Path")]
        public bool LUPath
        {
            get
            {
                return (bool)((SubType & 16) != 0 ? true : false);
            }
            set
            {
                SubType = (byte)((SubType & ~16) | (value == true ? 16 : 0));
            }
        }

        [DisplayName("Right/Down Priority")]
        public bool RDPriority
        {
            get
            {
                return (bool)((SubType & 32) != 0 ? true : false);
            }
            set
            {
                SubType = (byte)((SubType & ~32) | (value == true ? 32 : 0));
            }
        }

        [DisplayName("Left/Up Priority")]
        public bool LUPriority
        {
            get
            {
                return (bool)((SubType & 64) != 0 ? true : false);
            }
            set
            {
                SubType = (byte)((SubType & ~64) | (value == true ? 64 : 0));
            }
        }

        [DisplayName("Ground only")]
        public bool GroundOnly
        {
            get
            {
                return (bool)((SubType & 128) != 0 ? true : false);
            }
            set
            {
                SubType = (byte)((SubType & ~128) | (value == true ? 128 : 0));
            }
        }
    }
}
