package com.sQrt121.utils
{
    import flash.events.Event;
   
    public class CustomEvent extends Event
    {
  
        public var params:Object;

        public function CustomEvent($type:String, $params:Object, $bubbles:Boolean = true, $cancelable:Boolean = false)
        {
            super($type, $bubbles, $cancelable);
           
            this.params = $params;
        }
 
    }
}