"use strict";

function initMessageListener() {

  var postMessageListener = function(event) {
    var eventData = event.data || null;
    if (eventData) {
      try {
        var jsonEventData = JSON.parse(eventData);
        //Handle the message here (default behavior is to redirect to the target URL on success)
        if (jsonEventData.message === 'success' && jsonEventData.targetUrlOnSuccess) {
          window.location.assign(jsonEventData.targetUrlOnSuccess);
        }
      } catch (e) {
        //The message is not json, so not for us 
      }
    }
  };

  // Listen to message from child window
  if (window.addEventListener) {
    window.addEventListener('message', postMessageListener, false);
  } else if (window.attachEvent) {
    //For IE
    window.attachEvent('onmessage', postMessageListener, false);
  }
};

initMessageListener();