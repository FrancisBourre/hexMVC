package;

import hex.HexMVCSuite;
import hex.unittest.notifier.ConsoleNotifier;
import hex.unittest.runner.ExMachinaUnitCore;

/**
 * ...
 * @author Francis Bourre
 */
class MainMVCTest
{
	static public function main() : Void
	{
		var emu : ExMachinaUnitCore = new ExMachinaUnitCore();
        emu.addListener( new ConsoleNotifier() );
        emu.addTest( hex.HexMVCSuite );
        emu.run();
	}
}