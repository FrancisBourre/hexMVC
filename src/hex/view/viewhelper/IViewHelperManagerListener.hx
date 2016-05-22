package hex.view.viewhelper;

/**
 * @author Francis Bourre
 */
interface IViewHelperManagerListener 
{
	function onViewHelperCreation( viewHelper : ViewHelperTypedef ) : Void;
	
	function onViewHelperRelease( viewHelper : ViewHelperTypedef ) : Void;
}