package
{
	import org.flixel.*;
 
	public class MenuState extends FlxState
	{
		override public function create():void
		{
			bgColor = 0xff000000;
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Game");
			title.setFormat (null, 16, 0xFFFFFFFF, "center");
			add(title);
 
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 32, FlxG.width, "Press Z to start.");
			instructions.setFormat (null, 8, 0xFFFFFFFF, "center");
			add(instructions);
 
		} // end function create
 
 
		override public function update():void
		{
			super.update(); // calls update on everything you added to the game loop
 
			if (FlxG.keys.justPressed("Z"))
			{
				FlxG.state = new PlayState();
			}
 
		} // end function update
 
 
		public function MenuState()
		{
			super();
 
		}  // end function MenuState
 
	} // end class
}// end package