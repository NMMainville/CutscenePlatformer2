package
{
	import org.flixel.*;

	public class Light extends FlxSprite
	{
		[Embed(source="/../data/light.png")] private var LightImageClass:Class;
		private var thisDarkness:FlxSprite;
		private var screenXY:FlxPoint;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite):void
		{
			super(x, y, LightImageClass);
			loadGraphic(LightImageClass, false, true);
			thisDarkness = darkness;
			origin.x = 135;
			origin.y = 66;
			blend = "screen";
		}
		
		override public function render():void
		{
			screenXY = getScreenXY();
			
			thisDarkness.draw(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
	}
}