package
{
	import org.flixel.*;
 
	public class Ooze extends FlxSprite
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/ooze.png")] public var oozeSprites:Class; //sprites
		public var fadeOut:Boolean = false;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Ooze(X: int, Y: int):void
		{
			super(X, Y); //x and y position 
			
			loadGraphic(oozeSprites, true, false, 96, 160);
			
			addAnimation("idle", [0, 1, 2, 3], 12);
			play("idle");
		}
		
		override public function update():void //update function
		{
			if (fadeOut && alpha > 0) alpha = alpha - 0.01;
			else fadeOut = false;
			super.update();
		}
	}
}