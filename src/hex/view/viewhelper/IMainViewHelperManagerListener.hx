package hex.view.viewhelper;

/**
 * ...
 * @author Francis Bourre
 */
interface IMainViewHelperManagerListener
{
	function onViewHelperManagerCreation( event : MainViewHelperManagerEvent ) : Void;

	function onViewHelperManagerRelease( event : MainViewHelperManagerEvent ) : Void;
}