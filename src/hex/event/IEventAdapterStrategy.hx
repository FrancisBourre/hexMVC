package hex.event;

/**
 * @author Francis Bourre
 */

interface IEventAdapterStrategy 
{
	function adapt( args : Array<Dynamic> ) : Array<Dynamic>;
}