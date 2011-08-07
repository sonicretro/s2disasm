using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S2ObjectDefinitions.Common
{
    class Spikes : ObjectDefinition
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
            byte[][] artfile = new byte[2][];
            artfile[0] = ObjectHelper.OpenArtFile("../art/nemesis/Spikes.bin", Compression.CompressionType.Nemesis);
            artfile[1] = ObjectHelper.OpenArtFile("../art/nemesis/Long horizontal spike.bin", Compression.CompressionType.Nemesis);
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj36.bin");
            img = ObjectHelper.MapToBmp(artfile[0], mapfile, 0, 1, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            BitmapBits im;
            for (int i = 0; i < 8; i++)
            {
                im = ObjectHelper.MapToBmp(artfile[i / 4], mapfile, i, 1, out off);
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
            result += " " + ((MovingDirection)(subtype & 3)).ToString();
            result += " " + ((subtype & 0x40) == 0x40 ? "Horizontal" : "Vertical");
            return result;
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
            return imgs[(subtype & 0x70) >> 4];
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(imgs[(subtype & 0x70) >> 4]);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offsets[(subtype & 0x70) >> 4].X, loc.Y + offsets[(subtype & 0x70) >> 4].Y));
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

        public MovingDirection Moving
        {
            get
            {
                return (MovingDirection)(SubType & 3);
            }
            set
            {
                SubType = (byte)((SubType & ~3) | (int)value);
            }
        }
    }

    public enum MovingDirection
    {
        Static,
        Vertical,
        Horizontal,
        Invalid
    }
}