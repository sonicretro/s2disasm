using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.Common
{
	class MovingBlock : ObjectDefinition
	{
		private PropertySpec[] properties;
		private ReadOnlyCollection<byte> subtypesCPZ;
		private ReadOnlyCollection<byte> subtypesMTZ;
		private ReadOnlyDictionary<byte, string> names;
		private Sprite[] sprites;
		private ReadOnlyCollection<Size> sizes;		// corresponds to first two columns in Obj6B_Properties
		private readonly int[] stairRadii = { 0x10, 0x30, 0x50, 0x70 };

		public override void Init(ObjectData data)
		{
			var art = IsCPZ()
				? ObjectHelper.OpenArtFile("../art/nemesis/Moving block from CPZ.nem", CompressionType.Nemesis)
				: ObjectHelper.LevelArt;
			var map = IsCPZ() ? "../mappings/sprite/obj6B.asm" : "../mappings/sprite/obj65_a.asm";
			sprites = new Sprite[2];
			sprites[0] = new Sprite(ObjectHelper.MapASMToBmp(art, map, IsCPZ() ? 0 : 1, 3));
			sprites[1] = ObjectHelper.UnknownObject;
			if (IsCPZ()) Array.Reverse(sprites);
			subtypesCPZ = new ReadOnlyCollection<byte>(new byte[] { 0, 0x18, 0x19, 0x1A, 0x1B });
			subtypesMTZ = new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 7 });
			names = new ReadOnlyDictionary<byte, string>(new Dictionary<byte, string>()
			{
				{ 0, "Stationary" },
				{ 1, "Horizontal, short range" },
				{ 2, "Horizontal, long range" },
				{ 3, "Vertical, short range" },
				{ 4, "Vertical, long range" },
				{ 5, "Sinks when stood on" },
				{ 7, "Downward elevator" },
				{ 0x18, "Stair block , smallest range" },
				{ 0x19, "Stair block , small range" },
				{ 0x1A, "Stair block , large range" },
				{ 0x1B, "Stair block , largest range" }
			});
			sizes = new ReadOnlyCollection<Size>(new Size[] {
				new Size(0x20, 0x0C),
				new Size(0x10, 0x10)
			});
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get
			{
				return IsCPZ() ? subtypesCPZ : subtypesMTZ;
			}
		}

		public override string SubtypeName(byte subtype)
		{
			string name;
			names.TryGetValue(subtype, out name);
			return name;
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return IsCPZ() ? sprites[1] : sprites[0];
		}

		public override string Name { get { return "Moving Block"; } }

		public override Sprite Image
		{
			get { return IsCPZ() ? sprites[1] : sprites[0]; }
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			return new Sprite(GetSpriteFrame(obj), GetOffset(obj));
		}

		public override Rectangle GetBounds(ObjectEntry obj)
		{
			var spr = GetSpriteFrame(obj);
			var offset = GetOffset(obj);
			var pos = new Point(obj.Position.X + spr.Location.X + offset.X, obj.Position.Y + spr.Location.Y + offset.Y);
			return new Rectangle(pos,spr.Bounds.Size);
		}

		public override int GetDepth(ObjectEntry obj) { return 3; }

		public override Sprite GetDebugOverlay(ObjectEntry obj)
		{
			BitmapBits line;
			Point offset = new Point(0, 0);
			var behavior = GetBehavior(obj);
			switch (behavior)
			{
				case 1:
				case 2:
					line = new BitmapBits(behavior == 1 ? 0x40 : 0x80, 1);
					line.DrawLine(LevelData.ColorWhite, 0, 0, line.Width-1, 0);
					offset.X = -line.Width;
					break;

				case 3:
				case 4:
					line = new BitmapBits(1, behavior == 3 ? 0x40 : 0x80);
					line.DrawLine(LevelData.ColorWhite, 0, 0, 0, line.Height-1);
					offset.Y = -line.Height;
					break;

				case 5:
					line = new BitmapBits(1, 0x40);
					line.DrawLine(LevelData.ColorWhite, 0, 0, 0, line.Height-1 - 0x10);
					for (var y = line.Height-1 - 0x10; y < line.Height-1; y += 3)
					{
						line.SafeSetPixel(LevelData.ColorWhite, 0, y);
					}
					break;

				case 7:
					line = new BitmapBits(1, 0xE1);
					line.DrawLine(LevelData.ColorWhite, 0, 0, 0, line.Height-1);
					break;

				case 8:
				case 9:
				case 0xA:
				case 0xB:
					var length = 0x20;
					if (behavior == 9) length = 0x60;
					if (behavior == 0xA) length = 0xA0;
					if (behavior == 0xB) length = 0xE0;
					line = new BitmapBits(length, length);
					if (!obj.YFlip && !obj.XFlip)
					{
						line.DrawLine(LevelData.ColorWhite, 0, 0, line.Width-1, 0);
						line.DrawLine(LevelData.ColorWhite, line.Width-1, 0, line.Width-1, line.Height/4);
					}
					else if (!obj.YFlip && obj.XFlip)
					{
						line.DrawLine(LevelData.ColorWhite, line.Width-1, 0, line.Width-1, line.Height-1);
						line.DrawLine(LevelData.ColorWhite, 0, line.Height-1, line.Width/4, line.Height-1);
					}
					else if (obj.YFlip && ! obj.XFlip)
					{
						line.DrawLine(LevelData.ColorWhite, 0, line.Height-1, line.Width-1, line.Height-1);
						line.DrawLine(LevelData.ColorWhite, 0, line.Height-line.Height/4, 0, line.Height-1);
					}
					else
					{
						line.DrawLine(LevelData.ColorWhite, 0, 0, 0, line.Height-1);
						line.DrawLine(LevelData.ColorWhite, line.Width-line.Width/4, 0, line.Width-1, 0);
					}
					offset.X = -length/2;
					offset.Y = -length/2;
					break;

				default:
					return null;
			}
			return new Sprite(line, offset);
		}

		private bool IsCPZ()
		{
			return LevelData.Level.DisplayName.Remove(19) == "Chemical Plant Zone";
		}

		private bool IsValidSprite(int index)
		{
			return index < sprites.Length;
		}

		private Sprite GetSpriteFrame(byte subtype)
		{
			var index = (subtype & 0x70)>>4;
			return IsValidSprite(index) ? sprites[index] : ObjectHelper.UnknownObject;
		}

		private Sprite GetSpriteFrame(ObjectEntry obj)
		{
			return GetSpriteFrame(obj.SubType);
		}

		private int GetBehavior(byte subtype)
		{
			return subtype & 0x0F;
		}

		private int GetBehavior(ObjectEntry obj)
		{
			return GetBehavior(obj.SubType);
		}

		private Point GetOffset(ObjectEntry obj)
		{
			var offset = new Point(0, 0);
			var behavior = GetBehavior(obj);
			switch (behavior)
			{
				case 1:
				case 2:
					if (obj.XFlip) offset.X = behavior == 1 ? -0x40 : -0x80;
					break;

				case 3:
				case 4:
					if (obj.XFlip) offset.Y = behavior == 3 ? -0x40 : -0x80;
					break;

				case 8:
				case 9:
				case 0xA:
				case 0xB:
					var radius = offset.X = stairRadii[behavior - 8];
					offset.X = -radius;
					offset.Y = -radius;
					if (obj.YFlip ^ obj.XFlip) // offset *= -1;	// TODO need .Net version 4 or higher
					{
						offset.X *= -1;
						offset.Y *= -1;
					}
					break;
			}
			return offset;
		}
	}
}