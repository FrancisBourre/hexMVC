package hex.view.viewhelper;

import hex.event.Dispatcher;
import hex.event.IDispatcher;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.event.IEventListener;
import hex.event.LightweightClosureDispatcher;
import hex.event.MessageType;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class ViewHelper implements IViewHelper
{
	public static var DEFAULT_VISIBLE:Bool = true;
	
	@Inject
	public var dispatcher 			: IDispatcher<{}>;
	
	var _dispatcher 		: Dispatcher<{}>;
	var _owner 				: IModule;
	var _view 				: IView;
	var _isVisible 			: Bool = ViewHelper.DEFAULT_VISIBLE;
	
	var _isPreInitialized 	: Bool = false;
		
	
	public function new ()
	{
		this._dispatcher = new Dispatcher<{}>();
	}
	
	function _preInitialize() : Void
	{
		
	}

	function _initialize() : Void
	{

	}
	
	function _release() : Void
	{

	}
	
	public var view( get, set ) : IView;
	public function get_view() : IView 
	{
		return this._view;
	}
	
	public function set_view( view : IView ) : IView 
	{
		if ( !this._isPreInitialized )
		{
			this._preInitialize();
		}

		if ( this.view != null || view == null )
		{
			this._dispatcher.dispatch( ViewHelperMessage.REMOVE_VIEW, [ this, this._view ] );
		}
			
		this._view = view;
		
		if ( view != null )
		{
			this._dispatcher.dispatch( ViewHelperMessage.ATTACH_VIEW, [ this, this._view ] );

			if ( view.visible )
			{
				view.visible = this._isVisible;
			}
			else
			{
				this._isVisible = false;
			}
			
			//TODO: figure out when we should fire it. now it's automatic - grosmar
			this._fireInitialisation();
		}
		
		return this._view;
	}
	
	function _fireInitialisation() : Void
	{
		this._initialize();
		this._dispatcher.dispatch( ViewHelperMessage.INIT, [ this ] );
	}
	
	public function getOwner() : IModule
	{
		return this._owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
	
	public function show() : Void 
	{
		if ( !this._isVisible )
		{
			this._isVisible = true;
			if ( this._view != null )
			{
				this._view.visible = true;
			}
		}
	}
	
	public function hide() : Void 
	{
		if ( this._isVisible )
		{
			this._isVisible = false;
			if ( this._view != null )
			{
				this._view.visible = false;
			}
		}
	}
	
	public var visible( get, set ) : Bool;
	public function get_visible() : Bool 
	{
		return this._isVisible;
	}
	
	public function set_visible( visible : Bool ) : Bool 
	{
		if ( visible )
		{
			show();
		}
		else
		{
			hide();
		}

		return this._isVisible;
	}
	
	public function release() : Void 
	{
		this._dispatcher.dispatch( ViewHelperMessage.RELEASE, [ this ] );
		this._view = null;
		this._dispatcher.removeAllListeners();
	}
	
	public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		this._dispatcher.addHandler( messageType, scope, callback );
	}
	
	public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		this._dispatcher.removeHandler( messageType, scope, callback );
	}
}