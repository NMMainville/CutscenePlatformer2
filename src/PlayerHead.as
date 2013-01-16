package
{
	import org.flixel.*;
 
	public class PlayerHead extends FlxSprite
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/conniehead.png")] public var playerHeadsprites:Class; //player sprites
				private const ACCEL:int = 4; //Connie's X acceleration
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function PlayerHead(X: int, Y: int):void //X and Y define starting position of the player
		{
			super(X, Y); //x and y position of the player
			//Create player
			loadGraphic(playerHeadsprites, true, true, 19, 18);
			
			solid = false;
			//maxVelocity.x = 120; //maximum speed in the x direction
			//maxVelocity.y = 100; //maximum speed in the y direction
			//acceleration.y = 100; //player gravity
			//drag.x = maxVelocity.x * 4; //slows the player down when they're not moving left or right
			width = 15;
			offset.x = 2;
			
			origin.x = 10;
			origin.y = 10;
		}
		
		override public function update():void //update function
		{
			//------------------------------------------ANIMATIONS-----------------------------------------------
			
			//-------------------------------------------MOVEMENT------------------------------------------------
			
			super.update();
		}
	}
}