package hex.control.controller;

/**
 * @author Francis Bourre
 */
interface ICompletable<ResultType>
{
	function onComplete( result : ResultType->Void ) : ICompletable<ResultType>;
}