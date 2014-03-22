using System;
using System.Collections.Generic;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.Common
{
    class RingGroup : S2RingDefinition
    {
        private Sprite spr;
        private int spacing;

        public override void Init(ObjectData data)
        {
            if (data.Art != null)
            {
                MultiFileIndexer<byte> art = new MultiFileIndexer<byte>();
                foreach (FileInfo file in data.Art)
                    art.AddFile(new List<byte>(ObjectHelper.OpenArtFile(file.Filename, data.ArtCompression)), file.Offset);
                byte[] artfile = art.ToArray();
                if (data.MapFile != null)
                {
                    if (data.DPLCFile != null)
                        spr = ObjectHelper.MapDPLCToBmp(artfile, ObjectHelper.OpenArtFile(data.MapFile, data.MapCompression), data.MapVersion, ObjectHelper.OpenArtFile(data.DPLCFile, data.DPLCCompression), data.MapVersion, data.Frame, data.Palette);
                    else
                        spr = ObjectHelper.MapToBmp(artfile, ObjectHelper.OpenArtFile(data.MapFile, data.MapCompression), data.Frame, data.Palette, data.MapVersion);
                }
                else if (data.MapFileAsm != null)
                {
                    if (data.MapAsmLabel != null)
                    {
                        if (data.DPLCFileAsm != null)
                            spr = ObjectHelper.MapASMDPLCToBmp(artfile, data.MapFileAsm, data.MapAsmLabel, data.MapVersion, data.DPLCFileAsm, data.DPLCAsmLabel, data.MapVersion, data.Palette);
                        else
                            spr = ObjectHelper.MapASMToBmp(artfile, data.MapFileAsm, data.MapAsmLabel, data.Palette, data.MapVersion);
                    }
                    else
                    {
                        if (data.DPLCFileAsm != null)
                            spr = ObjectHelper.MapASMDPLCToBmp(artfile, data.MapFileAsm, data.MapVersion, data.DPLCFileAsm, data.MapVersion, data.Frame, data.Palette);
                        else
                            spr = ObjectHelper.MapASMToBmp(artfile, data.MapFileAsm, data.Frame, data.Palette, data.MapVersion);
                    }
                }
                else
                    spr = ObjectHelper.UnknownObject;
                if (data.Offset != Size.Empty)
                    spr.Offset = spr.Offset + data.Offset;
            }
            else if (data.Image != null)
            {
                BitmapBits img = new BitmapBits(new Bitmap(data.Image));
                spr = new Sprite(img, new Point(data.Offset));
            }
            else if (data.Sprite > -1)
                spr = ObjectHelper.GetSprite(data.Sprite);
            else
                spr = ObjectHelper.UnknownObject;
            spacing = int.Parse(data.CustomProperties.GetValueOrDefault("spacing", "24"), System.Globalization.NumberStyles.Integer, System.Globalization.NumberFormatInfo.InvariantInfo);
        }

        public override string Name
        {
            get { return "Rings"; }
        }

        public override Sprite Image
        {
            get { return spr; }
        }

        public override System.Drawing.Rectangle GetBounds(S2RingEntry rng, Point camera)
        {
            switch (rng.Direction)
            {
                case Direction.Horizontal:
                    return new Rectangle(rng.X + spr.X - camera.X, rng.Y + spr.Y - camera.Y, ((rng.Count - 1) * spacing) + spr.Width, spr.Height);
                case Direction.Vertical:
                    return new Rectangle(rng.X + spr.X - camera.X, rng.Y + spr.Y - camera.Y, spr.Width, ((rng.Count - 1) * spacing) + spr.Height);
            }
            return Rectangle.Empty;
        }

        public override Sprite GetSprite(S2RingEntry rng)
        {
            List<Sprite> sprs = new List<Sprite>();
            for (int i = 0; i < rng.Count; i++)
            {
                switch (rng.Direction)
                {
                    case Direction.Horizontal:
                        sprs.Add(new Sprite(spr.Image, new Point(spr.X + (i * spacing), spr.Y)));
                        break;
                    case Direction.Vertical:
                        sprs.Add(new Sprite(spr.Image, new Point(spr.X, spr.Y + (i * spacing))));
                        break;
                }
            }
            Sprite result = new Sprite(sprs.ToArray());
            result.Offset = new Point(spr.X + rng.X, spr.Y + rng.Y);
            return result;
        }
    }
}