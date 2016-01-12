package hex.view.viewhelper;

/**
 * ...
 * @author Francis Bourre
 */
interface IMainViewHelperManagerListener
{
	function onViewHelperManagerCreation( viewHelperManager : ViewHelperManager ) : Void;

	function onViewHelperManagerRelease( viewHelperManager : ViewHelperManager ) : Void;
}