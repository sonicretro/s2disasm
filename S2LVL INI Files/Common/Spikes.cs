using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using Extensions;
using S2LVL;

namespace S2ObjectDefinitions.Common
{
    class Spikes : ObjectDefinition
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
            byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Spikes.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj36.bin");
            img = ObjectHelper.MapToBmp(artfile, mapfile, 0, 1, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            Bitmap im;
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
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70 });
        }

        public override string Name()
        {
            return "Spikes";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            string result = (((subtype & 0x30) >> 4) + 1).ToString();
            result += " " + ((subtype & 1) == 1 ? "Moving" : "Still");
            result += " " + ((subtype & 0x40) == 0x40 ? "Horizontal" : "Vertical");
            return result;
        }

        public override string FullName(byte subtype)
        {
            return SubtypeName(subtype) + " " + Name();
        }

        public override Bitmap Image()
        {
            return img;
        }

        public override Bitmap Image(byte subtype)
        {
            return imgs[(subtype & 0x70) >> 4];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            gfx.DrawImageFlipped(imgs[(subtype & 0x70) >> 4], loc.X + offsets[(subtype & 0x70) >> 4].X, loc.Y + offsets[(subtype & 0x70) >> 4].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[(subtype & 0x70) >> 4].X, loc.Y + offsets[(subtype & 0x70) >> 4].Y, imgws[(subtype & 0x70) >> 4], imghs[(subtype & 0x70) >> 4]);
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(SpikesS2ObjectEntry);
            }
        }
    }

    public class SpikesS2ObjectEntry : S2ObjectEntry
    {
        public SpikesS2ObjectEntry() : base() { }
        public SpikesS2ObjectEntry(byte[] file, int address) : base(file, address) { }

        public byte Count
        {
            get
            {
                return (byte)(((SubType & 0x30) >> 4) + 1);
            }
            set
            {
                value = Math.Max((byte)1, value);
                value = Math.Min((byte)4, value);
                value--;
                SubType = (byte)((SubType & ~0x30) | (value << 4));
            }
        }

        public Direction Direction
        {
            get
            {
                return (SubType & 0x40) == 0x40 ? Direction.Vertical : Direction.Horizontal;
            }
            set
            {
                SubType = (byte)((SubType & ~0x40) | (value == Direction.Vertical ? 0x40 : 0));
            }
        }

        public bool Moving
        {
            get
            {
                return (SubType & 1) == 1;
            }
            set
            {
                SubType = (byte)((SubType & ~1) | (value ? 1 : 0));
            }
        }
    }
}