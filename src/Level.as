package
{
	import org.flixel.*;
 
	public class Level extends FlxTilemap
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		//[Embed(source = "../data/LVL1.txt", mimeType = "application/octet-stream")] private var TxtMap1:Class; //map layout 1
		[Embed(source = "../data/LVL1.png")] private var PngMap1:Class; //map layout 1 (png)
		[Embed(source = "../data/bg1.png")] private var BG1:Class; //map graphics 1
		
		private var parsedMap:Array;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Level():void //TODO: add in a property that denotes level number
		{
			//collideIndex = 1;
			//imageToCSV(PngMap1, false, 1);
			//loadMap(new TxtMap1, BG1, 16, 16);
			loadMap(imageToCSV(PngMap1, false, 1), BG1, 16, 16);
		}
				
		public function parseMap(tilemap:String):Array //this function takes a tilemap txt file and turns it into an array
		{								 //so that it can be used for other things (ie blocks)
			var tempArray:Array = new Array;
			var widthInTiles:int = 0;
			var heightInTiles:int = 0;
			var cols:Array;
			var rows:Array = tilemap.split("\n");
			heightInTiles = rows.length;
			for (var r:int = 0; r < heightInTiles; r++)
			{
				cols = rows[r].split(",");
				if(cols.length <= 1)
				{
					heightInTiles--;
					continue;
				}
				tempArray.push(new Array());
				if(widthInTiles == 0)
					widthInTiles = cols.length;
				for(var c:int = 0; c < widthInTiles; c++)
				{
					tempArray[r].push(uint(cols[c]));
				}
			}
			
			return tempArray;
		}
	}
}