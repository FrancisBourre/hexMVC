package hex.control;

/**
 * @author Francis Bourre
 */

interface ICancellable extends ICallable
{
	function cancel() : Void;
}