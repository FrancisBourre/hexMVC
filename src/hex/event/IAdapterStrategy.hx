package hex.event;

/**
 * @author Francis Bourre
 */

interface IAdapterStrategy 
{
	function adapt( args : Array<Dynamic> ) : Dynamic;
}