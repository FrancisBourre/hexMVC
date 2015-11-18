package hex.view.viewhelper;

import hex.event.BasicEvent;
import hex.view.IView;

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
	
	private var _view 						: IView;
	
	public function new ( eventType : String, target : IViewHelper, ?view : IView )
	{
		super( eventType, target );
	}
	
	public function getViewHelper() : IViewHelper
	{
		return cast this.target;
	}
}