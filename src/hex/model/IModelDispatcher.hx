package hex.model;

/**
 * @author Francis Bourre
 */
interface IModelDispatcher 
{
	function addListener( listener : IModelListener ) : Bool;

	function removeListener( listener : IModelListener ) : Bool;
}