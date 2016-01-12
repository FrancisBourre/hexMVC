package hex.view.viewhelper;

/**
 * @author Francis Bourre
 */
interface IViewHelperManagerListener 
{
	function onViewHelperCreation( viewHelper : ViewHelper ) : Void;
	
	function onViewHelperRelease( viewHelper : ViewHelper ) : Void;
}