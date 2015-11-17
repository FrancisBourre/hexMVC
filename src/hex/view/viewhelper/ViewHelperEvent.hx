package hex.view.viewhelper;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperEvent extends BasicEvent
{
	static public inline var INIT 			: String = "onInit";
	static public inline var RELEASE 		: String = "onRelease";
	static public inline var ATTACH_VIEW 	: String = "onAttachView";
	static public inline var REMOVE_VIEW 	: String = "onRemoveView";
	
	public function new ( eventType : String, target : IViewHelper )
	{
		super( eventType, target );
	}
	
	public function getViewHelper() : IViewHelper
	{
		return cast this.target;
	}
}