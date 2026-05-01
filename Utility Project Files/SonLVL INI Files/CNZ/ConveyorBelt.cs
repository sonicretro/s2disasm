using System;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.CNZ
{
	class ConveyorBelt : ObjectDefinition
	{
		private Sprite img;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../art/nemesis/Monitor and contents.nem", CompressionType.Nemesis);
			byte[] mapfile = System.IO.File.ReadAllBytes("../mappings/sprite/obj74.bin");
			img = ObjectHelper.MapToBmp(artfile, mapfile, 0, 0);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0 }); }
		}

		public override string Name
		{
			get { return "Conveyor Belt"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			return ((subtype & 0xF) * 2) + " blocks";
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return img;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int w = (obj.SubType & 0xF) * 16;
			int h = 3 * 16;
			BitmapBits bmp = new BitmapBits(w*2, h);
			if (obj.XFlip) {
				bmp.DrawLine(LevelData.ColorWhite, -w*2 + 1, (h/2), w, (h/2));
			} else {
				bmp.DrawLine(LevelData.ColorWhite, w, (h/2), w*2 - 1, (h/2));
			}
			bmp.DrawRectangle(LevelData.ColorWhite, 0, 0, w*2 - 1, h - 1);
			return new Sprite(new Sprite(bmp, new Point(-w, -h+16)), img);
		}

		public override bool Debug { get { return true; } }

		private PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Width", typeof(int), "Extended", null, null, GetWidth, SetWidth)
		};

		public override PropertySpec[] CustomProperties
		{
			get
			{
				return customProperties;
			}
		}

		private static object GetWidth(ObjectEntry obj)
		{
			return obj.SubType & 0xF;
		}

		private static void SetWidth(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)(Math.Min((int)value, 0xF) | (obj.SubType & 0xF0));
		}
	}
}
