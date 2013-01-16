package
{
	import org.flixel.*;
	import org.flixel.data.FlxQuake;
 
	public class PlayState extends FlxState
	{	
		//---------------------------------------CURRENT OBJECTIVES------------------------------------------
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/blackmaze.mp3")] private var stageMusic:Class; //music
		[Embed(source = "../data/kingsofseacut.mp3")] private var stageMusic2:Class; //music
		[Embed(source = "../data/bgfar.png")] private var BGfar:Class; //map graphics 1
		[Embed(source = "../data/fgfar.png")] private var FGfar:Class; //map graphics 2
		[Embed(source = "../data/bg2.png")] private var BG2:Class; //the second layer of the "level"
		[Embed(source = "../data/bg3.png")] private var BG3:Class; //the third layer of the "level"
		[Embed(source = "../data/porthole.png")] private var portHoleSprite:Class;
		[Embed(source = "../data/mmunit.png")] private var mmSprite:Class;
		public var bg:FlxSprite; //background object
		public var level:Level; //level object
		public var levelImage:FlxSprite; //level design
		public var levelForeground:FlxSprite; //level design foreground
		public var fg:FlxSprite; //foreground object
		
		public var player:FlxGroup; //player bodygroup
		public var playerBody:Player; //player body
		public var playerHead:PlayerHead; //player head
		
		public var mmUnit:FlxSprite; //the M.M. Unit
		public var portHole:FlxSprite; //the porthole
		public var ooze:Ooze; //the goo
		
		private var darkness:FlxSprite; //The darkness
		private var light:Light;
		
		private var textTrigger:int = 0;
		private var mmTrigger:Boolean = false;
		
		public var words:Text; //displays text
		public var musicPlaying:Boolean = false;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		override public function create():void
		{
			bgColor = 0xffffffff; //change bgcolour
			
			words = new Text(1*16, 12*16);
			words.scrollFactor = new FlxPoint(0, 0);
			words.actualWords.scrollFactor = new FlxPoint(0, 0);
			
			level = new Level(); //initiate level as a Level (the class)
			
			bg = new FlxSprite(0, 0);
			bg.loadGraphic(BGfar, false, false);
			
			fg = new FlxSprite(0, 0);
			fg.loadGraphic(FGfar, false, false);
			fg.scale = new FlxPoint(2, 2);
			
			levelImage = new FlxSprite(0, 0);
			levelImage.loadGraphic(BG2, false, false);
			
			levelForeground = new FlxSprite(0, 0);
			levelForeground.loadGraphic(BG3, false, false);
			
			playerHead = new PlayerHead( -100, -100);
			playerBody = new Player(8 * 16, -5 * 16, playerHead);
			//playerBody = new Player(70 * 16, 128 * 16, playerHead);
			
			portHole = new FlxSprite(50 * 16, 128 * 16);
			portHole.loadGraphic(portHoleSprite, false, false);
			mmUnit = new FlxSprite(52 * 16, 128 * 16);
			mmUnit.loadGraphic(mmSprite);
			mmUnit.alpha = 0;
			ooze = new Ooze(50 * 16 - 8, 119 * 16);
			
			player = new FlxGroup();
			player.add(playerBody, true);
			player.add(playerHead, true);
			
			darkness = new FlxSprite(0, 0); //initializing the darkness
			darkness.createGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			add(bg);
			add(level);
			add(levelImage);
			
			add(ooze);
			add(portHole);
			add(mmUnit);
			add(player);
			add(levelForeground);
			
			light = new Light(-10*16, -10*16, darkness);
			
			add(light);
			add(darkness);
			
			add(fg);
			add(words);
			add(words.actualWords);
			
			//set up camera
			bg.scrollFactor.x = 0.3;
			bg.scrollFactor.y = 0.4;
			fg.scrollFactor.x = 1.6;
			fg.scrollFactor.y = 1.4;
			
			FlxG.follow(playerBody,2.5);
			FlxG.followAdjust(0.5,0.0);
			level.follow();	//Set the followBounds to the map dimensions
			
			words.displayLines(1);
		}
		
		override public function update():void //update function
		{
			if (!musicPlaying)
			{
				FlxG.playMusic(stageMusic);
				musicPlaying = true;
			}
			light.x = playerHead.x + 7;
			light.y = playerHead.y + 8;
			light.angle = playerHead.angle;
			
			light.facing = playerHead.facing;
			//flavor dialogue triggers
			if (textTrigger == 0 && playerBody.y > 28 * 16)
			{
				words.displayLines(9);
				textTrigger = 1;
			}
			else if (textTrigger == 1 && playerBody.y > 90 * 16)
			{
				words.displayLines(17);
				textTrigger = 2;
			}
			else if (textTrigger == 2 && playerBody.y > 100 * 16)
			{
				FlxG.music.fadeOut(5);
				words.displayLines(20);
				textTrigger = 3;
			}
			else if (textTrigger == 3 && playerBody.x < 60 * 16 && !playerBody.cantMove)
			{
				FlxG.playMusic(stageMusic2);
				words.displayLines(22);
				textTrigger = 4;
				playerBody.cantMove = true;
			}
			
			if (words.currentNumber == 23) ooze.fadeOut = true;
			if (words.currentNumber == 24 && !mmTrigger)
			{
				mmUnit.acceleration.y = 60;
				mmUnit.velocity.y = -40;
				mmTrigger = true;
				FlxG.music.fadeOut(5);
			}
			else if (words.currentNumber == 24 && mmTrigger) mmUnit.alpha = mmUnit.alpha + 0.1;
			if (words.currentNumber == 25) playerBody.cantMove = false;
			
			if (mmTrigger)
			if (mmUnit.x < playerBody.x + 8) mmUnit.acceleration.x = 120;
			else if (mmUnit.x > playerBody.x + 8) mmUnit.acceleration.x = -120;
			
			if (mmUnit.x > playerBody.x - 8 && mmUnit.x < playerBody.x + 8 && mmTrigger)
			{
				mmUnit.kill();
			}
			
			if (playerBody.x < 0)
			{
				
				FlxG.fade.start(0xff000000, 2, onFade, false);
			}
			
			super.update();
			
			FlxU.collide(level, player);
			
			//if (FlxG.keys.justPressed("B")) FlxG.showBounds = !FlxG.showBounds; //bounding box debug
		}
		
	    override public function render():void
		{
			darkness.fill(0xff000000);
			super.render();
		}
		
		private function onFade():void
		{
			FlxG.state = new MenuState();
		}
	}
}