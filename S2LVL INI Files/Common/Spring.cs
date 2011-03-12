using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using Extensions;
using S2LVL;

namespace S2ObjectDefinitions.Common
{
    class Spring : ObjectDefinition
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
            byte[] artfile1 = ObjectHelper.OpenArtFile("../art/nemesis/Vertical spring.bin", Compression.CompressionType.Nemesis);
            byte[] artfile2 = ObjectHelper.OpenArtFile("../art/nemesis/Horizontal spring.bin", Compression.CompressionType.Nemesis);
            byte[] artfile3 = ObjectHelper.OpenArtFile("../art/nemesis/Diagonal spring.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile1, "../s2.asm", "word_19048", 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off = new Point();
            Bitmap im;
            imgs.Add(img); // 0
            offsets.Add(offset);
            imgws.Add(imgw);
            imghs.Add(imgh);
            im = ObjectHelper.MapASMToBmp(artfile1, "../s2.asm", "word_19048", 1, out off); // 1
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile2, "../s2.asm", "word_19076", 0, out off); // 2
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile2, "../s2.asm", "word_19076", 1, out off); // 3
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            imgs.Add(imgs[0]); // 4
            offsets.Add(offsets[0]);
            imgws.Add(imgws[0]);
            imghs.Add(imghs[0]);
            imgs.Add(imgs[1]); // 5
            offsets.Add(offsets[1]);
            imgws.Add(imgws[1]);
            imghs.Add(imghs[1]);
            im = ObjectHelper.MapASMToBmp(artfile3, "../s2.asm", "word_190B6", 0, out off); // 6
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile3, "../s2.asm", "word_19136", 1, out off); // 7
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            imgs.Add(imgs[6]); // 8
            offsets.Add(offsets[6]);
            imgws.Add(imgws[6]);
            imghs.Add(imghs[6]);
            imgs.Add(imgs[7]); // 9
            offsets.Add(offsets[7]);
            imgws.Add(imgws[7]);
            imghs.Add(imghs[7]);
            im = ObjectHelper.UnknownObject(out off); // A
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
            imgs.Add(im); // B
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
            imgs.Add(im); // C
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
            imgs.Add(im); // D
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
            imgs.Add(im); // E
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
            imgs.Add(im); // F
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Width);
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x40, 0x41, 0x42, 0x43 });
        }

        public override string Name()
        {
            return "Spring";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            string result = ((SpringColor)((subtype & 2) >> 1)).ToString();
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

        private int imgindex(byte subtype)
        {
            int result = (subtype & 2) >> 1;
            result |= (subtype & 0x70) >> 3;
            return result;
        }

        public override Bitmap Image(byte subtype)
        {
            return imgs[imgindex(subtype)];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            gfx.DrawImageFlipped(imgs[imgindex(subtype)], loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offsets[imgindex(subtype)].X, loc.Y + offsets[imgindex(subtype)].Y, imgws[imgindex(subtype)], imghs[imgindex(subtype)]);
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(SpringS2ObjectEntry);
            }
        }

        public override void PaletteChanged(System.Drawing.Imaging.ColorPalette pal)
        {
            img.Palette = pal;
            foreach (Bitmap item in imgs)
            {
                item.Palette = pal;
            }
        }
    }

    public class SpringS2ObjectEntry : S2ObjectEntry
    {
        public SpringS2ObjectEntry() : base() { }
        public SpringS2ObjectEntry(byte[] file, int address) : base(file, address) { }

        public SpringDirection Direction
        {
            get
            {
                return (SpringDirection)((SubType & 0x70) >> 4);
            }
            set
            {
                SubType = (byte)((SubType & ~0x70) | ((int)value << 4));
            }
        }

        public bool Twirl
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

        public SpringColor Color
        {
            get
            {
                return (SpringColor)((SubType & 2) >> 1);
            }
            set
            {
                SubType = (byte)((SubType & ~2) | ((int)value << 1));
            }
        }
    }

    public enum SpringDirection
    {
        Up,
        Horizontal,
        Down,
        DiagonalUp,
        DiagonalDown,
        Invalid1,
        Invalid2,
        Invalid3
    }

    public enum SpringColor
    {
        Red,
        Yellow
    }
}