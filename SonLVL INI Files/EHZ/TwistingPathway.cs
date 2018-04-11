using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;
using System;

namespace S2ObjectDefinitions.EHZ
{
	class TwistingPathway : ObjectDefinition
	{
		private Sprite img;
		private Sprite sprite;

		public override void Init(ObjectData data)
		{
			img = ObjectHelper.UnknownObject;
			List<Sprite> sprs = new List<Sprite>();
			int left = -208;
			int right = 208;
			int top = 0;
			int bottom = 0;
			for (int i = 0; i < Obj06_CosineTable.Length; i++)
			{
				top = Math.Min(Obj06_CosineTable[i], top);
				bottom = Math.Max(Obj06_CosineTable[i], bottom);
			}
			Point offset = new Point(left, top);
			BitmapBits bmp = new BitmapBits(right - left, bottom - top);
			for (int x = 0; x < 0x1A0; x++)
			{
				int y = Obj06_CosineTable[x] - top;
				if (x < bmp.Width & y >= 0 & y < bmp.Height)
					bmp[x, y] = 0x1C;
			}
			sprs.Add(new Sprite(bmp, offset));
			offset = new Point(-192, 0);
			bmp = new BitmapBits(0x180, 53);
			bmp.DrawLine(0x1C, 192, 0, 192, 52);
			bmp.DrawLine(0x1C, 0, 52, 0x180, 52);
			sprs.Add(new Sprite(bmp, offset));
			sprs.Add(img);
			sprite = new Sprite(sprs.ToArray());
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0 }); }
		}

		public override string Name
		{
			get { return "Twisting Pathway"; }
		}

		public override string SubtypeName(byte subtype)
		{
			return string.Empty;
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return img;
		}

		private int[] Obj06_CosineTable = {
	      32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, // 16
	      32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 31, 31, // 32
	      31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 30, 30, 30, // 48
	      30, 30, 30, 30, 30, 30, 29, 29, 29, 29, 29, 28, 28, 28, 28, 27, // 64
	      27, 27, 27, 26, 26, 26, 25, 25, 25, 24, 24, 24, 23, 23, 22, 22, // 80
	      21, 21, 20, 20, 19, 18, 18, 17, 16, 16, 15, 14, 14, 13, 12, 12, // 96
	      11, 10, 10,  9,  8,  8,  7,  6,  6,  5,  4,  4,  3,  2,  2,  1, //112
	       0, -1, -2, -2, -3, -4, -4, -5, -6, -7, -7, -8, -9, -9,-10,-10, //128
	     -11,-11,-12,-12,-13,-14,-14,-15,-15,-16,-16,-17,-17,-18,-18,-19, //144
	     -19,-19,-20,-21,-21,-22,-22,-23,-23,-24,-24,-25,-25,-26,-26,-27, //160
	     -27,-28,-28,-28,-29,-29,-30,-30,-30,-31,-31,-31,-32,-32,-32,-33, //176
	     -33,-33,-33,-34,-34,-34,-35,-35,-35,-35,-35,-35,-35,-35,-36,-36, //192
	     -36,-36,-36,-36,-36,-36,-36,-37,-37,-37,-37,-37,-37,-37,-37,-37, //208
	     -37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37, //224
	     -37,-37,-37,-37,-36,-36,-36,-36,-36,-36,-36,-35,-35,-35,-35,-35, //240
	     -35,-35,-35,-34,-34,-34,-33,-33,-33,-33,-32,-32,-32,-31,-31,-31, //256
	     -30,-30,-30,-29,-29,-28,-28,-28,-27,-27,-26,-26,-25,-25,-24,-24, //272
	     -23,-23,-22,-22,-21,-21,-20,-19,-19,-18,-18,-17,-16,-16,-15,-14, //288
	     -14,-13,-12,-11,-11,-10, -9, -8, -7, -7, -6, -5, -4, -3, -2, -1, //304
	       0,  1,  2,  3,  4,  5,  6,  7,  8,  8,  9, 10, 10, 11, 12, 13, //320
	      13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, //336
	      21, 22, 22, 23, 23, 24, 24, 24, 25, 25, 25, 25, 26, 26, 26, 26, //352
	      27, 27, 27, 27, 28, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 29, //368
	      29, 30, 30, 30, 30, 30, 30, 30, 31, 31, 31, 31, 31, 31, 31, 31, //384
	      31, 31, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, //400
	      32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, //416
										  };
        
		public override Sprite GetSprite(ObjectEntry obj)
		{
			return sprite;
		}

		public override Rectangle GetBounds(ObjectEntry obj)
		{
			return new Rectangle(obj.X + img.X, obj.Y + img.Y, img.Width, img.Height);
		}

		public override bool Debug { get { return true; } }
	}
}
