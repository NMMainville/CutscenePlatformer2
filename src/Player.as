package
{
	import org.flixel.*;
 
	public class Player extends FlxSprite
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/conniesprites.png")] public var playerSprites:Class; //player sprites
		[Embed(source= "../data/walk1.mp3")] private var walkSound1:Class; //walk sound
		[Embed(source= "../data/walk2.mp3")] private var walkSound2:Class; //walk sound
				private const ACCEL:int = 4; //Connie's X acceleration
				private const MAXHEADANGLE:int = 450; //take angle and multiply by 10
				private const WALKMODIFIER:Number = 2; //walking speed modifier
				private const JUMPMODIFIER:Number = 3.5; //jumping speed modifier
				private var playerHead:FlxSprite;
				private var neckX:int = 2;
				private var neckY:int = -14;
				private var velocityJustHitZero:Boolean = false;
				private var walkStep:Boolean = false;
				private var jumpStep:Boolean = false;
				private var inAir:Boolean = false;
				private var decideRunningSprite:Boolean = true;
				private var oldfacing:int = LEFT;
				private var angleint:int = 0;
				private var lastXpos:int = 0;
				private var fallingStraightDown: Boolean = true;
				public var cantMove:Boolean = false;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Player(X: int, Y: int, head:FlxSprite):void //X and Y define starting position of the player, as well as the player's head
		{
			super(X, Y); //x and y position of the player
			
			playerHead = head;
			
			//Create player
			loadGraphic(playerSprites, true, true, 83, 53);
			
			maxVelocity.x = 120; //maximum speed in the x direction
			maxVelocity.y = 70; //maximum speed in the y direction
			acceleration.y = 60; //player gravity
			//drag.x = maxVelocity.x * 4; //slows the player down when they're not moving left or right
			
			width = 15;
			height = 40;
			offset.y = 12;
			offset.x = 34;
			
			addAnimationCallback(detectFrame);
			
			addAnimation("idle", [0, 0], 60);
			addAnimation("prewalk", [2, 2], 6);
			addAnimation("jump1", [1, 1], 60);
			addAnimation("jump2", [3, 3], 60);
			addAnimation("preleap", [4, 4], 6);
			addAnimation("leap", [5, 5], 60);
			
			play("leap");
			inAir = true;
		}
		
		override public function update():void //update function
		{
			//-------------------------------------------MOVEMENT------------------------------------------------
			//TODO: ability to simply "step over" 1-block-high walls?
					//Might be easiest to just increase walk height to above 1 block and always retain momentum to pass over it
			if (onFloor && inAir)
			{
				velocity.x = 0;
				inAir = false;
				if (fallingStraightDown) fallingStraightDown = false;
				FlxG.play(walkSound1, 1, false);
				play("idle");
			}
			
			if (walkStep)
			{
				inAir = true;
				velocity.y = -maxVelocity.y / 1.5;
				if (facing == RIGHT) velocity.x = maxVelocity.x/WALKMODIFIER;
				else if (facing == LEFT) velocity.x = -maxVelocity.x/WALKMODIFIER;
				walkStep = false;
			}
			else if (jumpStep)
			{
				inAir = true;
				velocity.y = -maxVelocity.y;
				if (FlxG.keys.RIGHT) velocity.x = maxVelocity.x/JUMPMODIFIER;
				else if (FlxG.keys.LEFT) velocity.x = -maxVelocity.x/JUMPMODIFIER;
				jumpStep = false;
			}
			//-----------------------------------------HEAD CONTROL----------------------------------------------
			switch(frame) //contains head positioning data for every frame of animation
			{
				case 0:
					neckX = 2;
					neckY = -14;
				break;
				case 1:
					neckX = 5;
					neckY = -14;
				break;
				case 2:
					neckX = 4;
					neckY = -12;
				break;
				case 3:
					neckX = 3;
					neckY = -14;
				break;
				case 4:
					neckX = 2;
					neckY = -13;
				break;
				case 5:
					neckX = 3;
					neckY = -19;
				break;
			}
			
			affixHeadtoBody();
			
			super.update();
			
			lastXpos = x;
		}
		
		public function detectFrame(animState:String, frameNo:int, spriteNo:int):void //reads the animation state
		{
			if (animState == "idle" && (FlxG.keys.RIGHT || FlxG.keys.LEFT) && !FlxG.keys.Z && !cantMove)
			{
				if (FlxG.keys.RIGHT) facing = RIGHT;
				else if (FlxG.keys.LEFT) facing = LEFT;
				play("prewalk");
			}
			else if (animState == "idle" && FlxG.keys.Z && !cantMove)
			{
				if (FlxG.keys.RIGHT) facing = RIGHT;
				else if (FlxG.keys.LEFT) facing = LEFT;
				play("preleap");
			}
			if (animState == "prewalk" && frameNo == 1)
			{
				if (FlxG.keys.RIGHT || FlxG.keys.LEFT)
				{
					walkStep = true;
					if (decideRunningSprite)
					{
						decideRunningSprite = false;
						play("jump1");
					}
					else
					{
						decideRunningSprite = true;
						play("jump2");
					}
				}
				else play("idle");
			}
			else if (animState == "preleap" && frameNo == 1)
			{
				if (FlxG.keys.RIGHT || FlxG.keys.LEFT)
				{
					if (FlxG.keys.RIGHT) facing = RIGHT;
					else if (FlxG.keys.LEFT) facing = LEFT;
					jumpStep = true;
					FlxG.play(walkSound2, 1, false);
					play("leap");
				}
				else play("idle");
			}
			
			if ((animState == "jump1" || animState == "jump2") && inAir)
			{
				if (facing == RIGHT) velocity.x = maxVelocity.x/WALKMODIFIER;
				else if (facing == LEFT) velocity.x = -maxVelocity.x/WALKMODIFIER;
			}
			if (animState == "leap" && inAir)
			{
				if (!fallingStraightDown)
				{
					if (facing == RIGHT) velocity.x = maxVelocity.x/JUMPMODIFIER;
					else if (facing == LEFT) velocity.x = -maxVelocity.x / JUMPMODIFIER;
				}
			}
		}
		
		public function affixHeadtoBody(): void
		{
			if (facing == RIGHT) playerHead.x = x + neckX;
			if (facing == LEFT) playerHead.x = x - neckX;
			
			if (lastXpos != x) playerHead.velocity.x = velocity.x * 1;
			else playerHead.velocity.x = 0;
			
			if(!onFloor)
			{
				playerHead.y = y + neckY + 8;
				playerHead.velocity.y = velocity.y * 1 + 0.9;
				if (!velocityJustHitZero) velocityJustHitZero = true;
			}
			if (velocity.y == 0 && velocityJustHitZero)
			{
				playerHead.velocity.y = 0;
				playerHead.y = y + neckY + 8;
				velocityJustHitZero = false;
			}
			else if (onFloor)
			{
				playerHead.velocity.y = 0;
				playerHead.y = y + neckY + 8;
			}
			if (!inAir) playerHead.facing = facing;
			else if (FlxG.keys.LEFT) playerHead.facing = LEFT;
			else if (FlxG.keys.RIGHT) playerHead.facing = RIGHT;
			playerHead.angle = getHeadAngle();
		}
		
		public function getHeadAngle(): Number
		{
			if (playerHead.facing == RIGHT)
			{
				if (FlxG.keys.UP && angleint > -MAXHEADANGLE)
					angleint = angleint + (-MAXHEADANGLE - angleint) / 10;
				else if (FlxG.keys.DOWN && angleint < MAXHEADANGLE)
					angleint = angleint - (angleint - MAXHEADANGLE) / 10;
				else
					angleint = angleint * 0.9;
			}
			else if (playerHead.facing == LEFT)
			{
				if (FlxG.keys.UP && angleint < MAXHEADANGLE)
					angleint = angleint - (angleint - MAXHEADANGLE) / 10;
				else if (FlxG.keys.DOWN && angleint > -MAXHEADANGLE)
					angleint = angleint + ( -MAXHEADANGLE - angleint) / 10;
				else
					angleint = angleint * 0.9;
			}
			
			if (playerHead.facing == LEFT && oldfacing == RIGHT)
			{
				angleint = angleint * -1;
				oldfacing = LEFT;
			}
			else if (playerHead.facing == RIGHT && oldfacing == LEFT)
			{
				angleint = angleint * -1;
				oldfacing = RIGHT;
			}
			
			return angleint / 10;
		}
		
	}
}