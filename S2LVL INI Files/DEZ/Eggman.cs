using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL;

namespace S2ObjectDefinitions.DEZ
{
    class Eggman : SonicRetro.SonLVL.ObjectDefinition
    {
        private Point offset;
        private BitmapBits img;
        private int imgw, imgh;

        public override void Init(Dictionary<string, string> data)
        {
            List<byte> tmpartfile = new List<byte>(new byte[0xA000]);
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("../art/nemesis/Robotnik's head.bin", Compression.CompressionType.Nemesis));
            tmpartfile.AddRange(new byte[0xA300 - tmpartfile.Count]);
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("../art/nemesis/Robotnik.bin", Compression.CompressionType.Nemesis));
            tmpartfile.AddRange(new byte[0xAC80 - tmpartfile.Count]);
            tmpartfile.AddRange(ObjectHelper.OpenArtFile("../art/nemesis/Robotnik's lover half.bin", Compression.CompressionType.Nemesis));
            byte[] artfile = tmpartfile.ToArray();
            byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/objC6_a.bin");
            img = ObjectHelper.MapToBmp(artfile, mapfile, 0, 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0 });
        }

        public override string Name()
        {
            return "Eggman";
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

        public override BitmapBits Image()
        {
            return img;
        }

        public override BitmapBits Image(byte subtype)
        {
            return img;
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            return new Rectangle(loc.X + offset.X, loc.Y + offset.Y, imgw, imgh);
        }

        public override void Draw(BitmapBits bmp, Point loc, byte subtype, bool XFlip, bool YFlip, bool includeDebug)
        {
            BitmapBits bits = new BitmapBits(img);
            bits.Flip(XFlip, YFlip);
            bmp.DrawBitmapComposited(bits, new Point(loc.X + offset.X, loc.Y + offset.Y));
        }
    }
}
