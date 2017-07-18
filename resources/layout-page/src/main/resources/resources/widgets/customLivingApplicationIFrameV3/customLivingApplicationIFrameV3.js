(function () {
  try {
    return angular.module('bonitasoft.ui.widgets');
  } catch(e) {
    return angular.module('bonitasoft.ui.widgets', []);
  }
})().directive('customLivingApplicationIFrameV3', function() {
    return {
      controllerAs: 'ctrl',
      controller: function WidgetlivingApplicationIFrameController($scope, $element, $interval, $sce) {

    function handleResizeContent() {
        if ($scope.properties.resizeToContent) {
            
            var iframe = $element.find('iframe')[0];
        
            var polling = $interval(function() {
                if(iframe.contentDocument.documentElement){
        			iframe.style.height = (iframe.contentDocument.documentElement.scrollHeight || 400) + "px";
        		}
            }, 100);
            
            $scope.$on('$destroy', function() {
                $interval.cancel(polling);
            });
                
        }
    }
    
    handleResizeContent();
    
    $scope.$watch(function(){
        return $scope.properties.src
    }, function() {
        //Rebuild iframe on menu change in order to prevent issues with the browser's back button
        var iframes = $element.find('iframe');
        if (iframes.length > 0) {
            var iframeToRemeove = iframes[0];
            var parentDiv = iframeToRemeove.parentNode;
            parentDiv.removeChild(iframeToRemeove);
        }
        var iframe = document.createElement('iframe');
        iframe.setAttribute("id", "bonitaframe");
        iframe.setAttribute("src",  $sce.trustAsResourceUrl($scope.properties.src));
        iframe.setAttribute("width", "100%");
        iframe.setAttribute("border", "0");
        $element.append(iframe);
        handleResizeContent();
    });
    
},
      template: ''
    };
  });
