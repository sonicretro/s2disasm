using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.MTZ
{
	class RotatingCylinder : ObjectDefinition
	{
		private const int SONIC_Y_RADIUS = 0x13;
		private const int X_RADIUS = 0xC0;
		private const int Y_RADIUS = 0x28 + SONIC_Y_RADIUS;

		private ReadOnlyCollection<byte> subtypes;

		public override void Init(ObjectData data)
		{
			subtypes = new ReadOnlyCollection<byte>(new byte[] { 0x80 });
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return subtypes; }
		}

		public override string SubtypeName(byte subtype)
		{
			return null;
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return ObjectHelper.UnknownObject;
		}

		public override string Name
		{
			get { return "Rotating Cylinder"; }
		}

		public override byte DefaultSubtype
		{
			get { return 0x80; }
		}

		public override Sprite Image
		{
			get { return ObjectHelper.UnknownObject; }
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			return ObjectHelper.UnknownObject;
		}

		public override Rectangle GetBounds(ObjectEntry obj)
		{
			return new Rectangle(obj.X -X_RADIUS, obj.Y -Y_RADIUS, X_RADIUS*2, Y_RADIUS*2);
		}

		public override Sprite GetDebugOverlay(ObjectEntry obj)
		{
			var rect = new BitmapBits(X_RADIUS*2, Y_RADIUS*2);
			rect.DrawRectangle(LevelData.ColorWhite, 0, 0, rect.Width-1, rect.Height-1);
			rect.DrawLine(LevelData.ColorYellow, 1, SONIC_Y_RADIUS, rect.Width-2, SONIC_Y_RADIUS);
			rect.DrawLine(LevelData.ColorYellow, 1, rect.Height-SONIC_Y_RADIUS, rect.Width-2, rect.Height-SONIC_Y_RADIUS);
			return new Sprite(rect, -X_RADIUS, -Y_RADIUS);
		}

		public override bool Debug
		{
			get { return true; }
		}
	}
}