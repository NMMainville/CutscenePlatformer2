package
{
	import flash.display.Graphics;
	import org.flixel.*;
 
	public class Text extends FlxSprite
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/Dialogue.txt", mimeType = "application/octet-stream")] private var TxtConvo:Class; //File containing all dialogue
		public var convoList:Array;
		private const convo:String = new TxtConvo;
		public var convoBox:FlxSprite;
		public var actualWords:FlxText;
		private var countDown:int;
		public var currentNumber:int;
		private var cancelString:String;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Text(X: int, Y: int):void
		{	
			super(X, Y); //x and y position of the text
			
			actualWords = new FlxText(X + 1 * 16, Y + 4, 16 * 16, "");
			
			convoList = parseText(convo);
			
			convoBox = createGraphic(18 * 16, 2 * 16, 0xff000000);
			convoBox.alpha = 0.5;
			
			countDown = actualWords.text.length * 10;
			//FlxG.log(countDown);
			cancelString = convoList[0];
		}

		override public function update():void //update function
		{
			if (countDown >= 0)
			{
				countDown--;
				//FlxG.log(countDown);
			}
			if (countDown == 0 && convoList[currentNumber + 1] == cancelString)
			{
				countDown--;
				convoBox.alpha = 0;
				actualWords.alpha = 0;
			}
			else if (countDown == 0 && convoList[currentNumber + 1] != cancelString)
			{
				displayLines(currentNumber + 1);
			}
			
			super.update();
		}
		
		public function parseText(convo:String):Array //this function takes a txt file and loads it into an array
		{								 //so that it can be used for other things (ie blocks)
			var lines:Array = convo.split("\n");
			return lines;
		}
		
		public function displayLines(number:int):void //this function actually displays the text
		{
			currentNumber = number;
			convoBox.alpha = 0.5;
			actualWords.text = convoList[number];
			actualWords.alpha = 1;
			countDown = actualWords.text.length * 10;
		}
	}
}