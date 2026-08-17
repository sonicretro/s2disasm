using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.MTZ
{
	class TriggerPlatform : ObjectDefinition
	{
		private const int COG_MAPFRAME = 2;
		private const int MTZ_1_PLATFORM_START = 0x1880;
		private const int MTZ_1_PLATFORM_END = 0x1BC0;
		private const int MTZ_3_PLATFORM_END_1 = 0x1CC0;
		private const int MTZ_3_PLATFORM_END_2 = 0x2940;
		private const string MTZ_3_DISPLAY_NAME = "Metropolis Zone Act 3";

		private PropertySpec[] properties;
		private ReadOnlyCollection<byte> subtypes;
		private Sprite[] sprites;
		private ReadOnlyCollection<Size> sizes;		// corresponds to first two columns in Obj65_Properties
		private ReadOnlyCollection<byte> offsets;	// corresponds to third column in Obj65_Properties
		private ReadOnlyCollection<byte> behaviors;	// corresponds to fourth column in Obj65_Properties

		public override string Name
		{
			get { return "Trigger Platform"; }
		}

		public override Sprite Image
		{
			get { return sprites[0]; }
		}

		public override PropertySpec[] CustomProperties
		{
			get { return properties; }
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return subtypes; }
		}

		public override string SubtypeName(byte subtype)
		{
			if (subtype == 0x04)
				return "horizontal lift";
			else if (subtype == 0x13)
				return "one-way floor";
			else if (subtype == 0x20)
				return "small cog";
			else if ((subtype & 0xF0) == 0x80)
				return "retracts w. switch " + (subtype & 0x0F).ToString("X2");
			else if ((subtype & 0xF0) == 0xB0)
				return "extends w. switch " + (subtype & 0x0F).ToString("X2");
			else
				return null;	// invalid subtype
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			var sprite = new Sprite(GetSpriteFrame(subtype), GetOffset(subtype));
			if (HasSwitchID(subtype))
				sprite = new Sprite(new Sprite(sprites[COG_MAPFRAME], -0x4C - (-0x18), 0x14), sprite);
			return sprite;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			var sprite = new Sprite(GetSpriteFrame(obj), GetOffset(obj));
			if (HasSwitchID(obj.SubType))
				sprite = new Sprite(new Sprite(sprites[COG_MAPFRAME], obj.XFlip ? -0x4C : -0x4C - (-0x18), 0x14), sprite);
			return sprite;
		}

		public override Rectangle GetBounds(ObjectEntry obj)
		{
			// TODO needs .Net 4 or above
			//return new Rectangle(obj.pos + GetOffset(obj) - GetRadius(obj));
			var offset = GetOffset(obj);
			var radius = GetRadius(obj);
			var pos = new Point(obj.X + offset.X - radius.Width, obj.Y + offset.Y - radius.Height);
			return new Rectangle(pos, GetDiameter(obj));
		}

		public override Sprite GetDebugOverlay(ObjectEntry obj)
		{
			if (!IsValid(obj.SubType))
				return null;
			Sprite sprite;
			var behavior = GetBehavior(obj.SubType);
			switch (behavior)
			{
				case 4:
					var origin = MTZ_1_PLATFORM_START;
					var target = MTZ_1_PLATFORM_END;
					if (LevelData.Level.DisplayName == MTZ_3_DISPLAY_NAME)
					{
						origin = obj.X;
						target = MTZ_3_PLATFORM_END_1;
						if (obj.X >= target)
							target = MTZ_3_PLATFORM_END_2;
					}
					if (obj.X > target || obj.X % 2 != 0)
					{
						var dottedLine = new BitmapBits(0x80, 1);
						dottedLine.DrawLine(LevelData.ColorYellow, 0, 0, 0x60 - 1, 0);
						for (int x = 0x60; x < dottedLine.Width - 1; x += 3)
							dottedLine.SafeSetPixel(LevelData.ColorYellow, x, 0);
						sprite = new Sprite(dottedLine);
					}
					else
					{
						var length = target - origin;
						var line = new BitmapBits(length, 1);
						line.DrawLine(LevelData.ColorWhite, 0, 0, line.Width - 1, 0);
						sprite = new Sprite(line);
						sprite.Offset(origin - obj.X, 0);
					}
					break;
				case 1:
				case 3:
				case 7:
					var radius = GetRadius(obj);
					var rect = new BitmapBits(GetDiameter(obj));
					rect.DrawRectangle(LevelData.ColorWhite, 0, 0, rect.Width-1, rect.Height-1);
					sprite = new Sprite(rect);
					// TODO needs .Net 4 or above
					//sprite.Offset(GetOffset(obj.SubType, !obj.XFlip) - radius);
					sprite.Offset(GetOffset(obj.SubType, !obj.XFlip));
					sprite.Offset(-radius.Width, -radius.Height);
					break;
				default:
					return null;
			}
			return sprite;
		}

		public override int GetDepth(ObjectEntry obj)
		{
			return 4;
		}

		public override void Init(ObjectData data)
		{
			var art = ObjectHelper.LevelArt;
			var map = "../mappings/sprite/obj65_a.asm";
			var cogArt = ObjectHelper.OpenArtFile("../art/nemesis/Small cog from MTZ.nem", CompressionType.Nemesis);
			var cogMap = "../mappings/sprite/obj65_b.asm";
			var switchIDs = new Dictionary<string, int>();
			properties = new PropertySpec[1];
			subtypes = new ReadOnlyCollection<byte>(ListSubtypes());
			sprites = new Sprite[4];
			sizes = new ReadOnlyCollection<Size>(new Size[] {
				new Size(0x40, 0x0C),
				new Size(0x20, 0x0C),
				new Size(0x0C, 0x0C),	// is (0x10, 0x10) in source and unused, but altered here for display purposes
				new Size(0x40, 0x0C)
			});
			offsets = new ReadOnlyCollection<Byte>(new byte[] { 0x80, 0x40, 0x20, 0x80 });
			behaviors = new ReadOnlyCollection<Byte>(new byte[] { 1, 3, 0, 7 });
			for (var index = 0; index < sprites.Length; index++)
			{
				if (index != COG_MAPFRAME)
				{
					sprites[index] = new Sprite(ObjectHelper.MapASMToBmp(art, map, index, 3));
				}
				else
				{
					sprites[index] = new Sprite(ObjectHelper.MapASMToBmp(cogArt, cogMap, 0, 3));
				}
			}
			for (var id = 0; id < 0x10; id++)
			{
				switchIDs.Add("Switch " + id.ToString("X2"), id);
			}
			switchIDs.Add("Unused", -1);
			properties[0] = new PropertySpec("Switch ID", typeof(Nullable<int>), "Extended",
				"The level trigger array flag set by this object.", null, switchIDs,
				(obj) => HasSwitchID(obj.SubType) ? obj.SubType & 0x0F : -1,
				(obj, value) => obj.SubType = (byte)(
					HasSwitchID(obj.SubType)
					? (obj.SubType & 0xF0) | ((int)value & 0x0F)
					: obj.SubType));
		}

		private List<byte> ListSubtypes()
		{
			var subtypes = new List<byte>() { 0x04, 0x13, 0x20 };
			for (var type = 0x80; type <= 0xB0; type += 0x30)
			{
				for (var id = 0; id < 0x10; id++)
				{
					subtypes.Add((byte)(type | id));
				}
			}
			return subtypes;
		}

		private bool HasSwitchID(byte subtype)
		{
			return (subtype & 0x80) != 0;
		}

		private int GetType(byte subtype)
		{
			return (subtype & 0x70)>>4;
		}

		private bool IsValid(byte subtype)
		{
			return subtypes.Contains(subtype);
		}

		private bool IsValid(ObjectEntry obj)
		{
			return IsValid(obj);
		}

		private int GetBehavior(byte subtype)
		{
			return !IsValid(subtype) || !HasSwitchID(subtype) ? (subtype & 0x0F) : behaviors[GetType(subtype)];
		}

		private Sprite GetSpriteFrame(byte subtype)
		{
			return IsValid(subtype) ? sprites[GetType(subtype)] : ObjectHelper.UnknownObject;
		}

		private Sprite GetSpriteFrame(ObjectEntry obj)
		{
			return new Sprite(GetSpriteFrame(obj.SubType), obj.XFlip, obj.YFlip);
		}

		private Size GetRadius(byte subtype)
		{
			if (!IsValid(subtype))
			{
				// TODO needs .Net 4 or above
				// return ObjectHelper.UnknownObject.Size/2;
				var radius = ObjectHelper.UnknownObject.Size;
				radius.Width /= 2;
				radius.Height /= 2;
				return radius;
			}
			return sizes[GetType(subtype)];
		}

		private Size GetRadius(ObjectEntry obj)
		{
			return GetRadius(obj.SubType);
		}

		private Size GetDiameter(byte subtype)
		{
			if (!IsValid(subtype))
				return ObjectHelper.UnknownObject.Size;
			// TODO needs .Net 4 or above
			//return GetRadius(subtype)*2;
			var diameter = GetRadius(subtype);
			diameter.Width *= 2;
			diameter.Height *= 2;
			return diameter;
		}

		private Size GetDiameter(ObjectEntry obj)
		{
			return GetDiameter(obj.SubType);
		}

		private Point GetOffset(byte subtype, bool xFlip = false)
		{
			if (!IsValid(subtype))
				return new Point(0, 0);
			var xOffset = 0;
			var behavior = GetBehavior(subtype);
			switch (behavior) {
				case 1:
				case 3:
				case 7:
					xOffset = offsets[GetType(subtype)];
					break;
			}
			xOffset *= xFlip ^ behavior == 7 ? -1 : 0;
			return new Point(xOffset, 0);
		}

		private Point GetOffset(ObjectEntry obj)
		{
			return GetOffset(obj.SubType, obj.XFlip);
		}
	}
}