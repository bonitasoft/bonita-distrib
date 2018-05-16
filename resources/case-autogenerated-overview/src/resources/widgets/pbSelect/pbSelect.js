(function () {
  try {
    return angular.module('bonitasoft.ui.widgets');
  } catch(e) {
    return angular.module('bonitasoft.ui.widgets', []);
  }
})().directive('pbSelect', function() {
    return {
      controllerAs: 'ctrl',
      controller: function PbSelectCtrl($scope, $parse, $log, widgetNameFactory, $timeout, $window, $element) {
  var ctrl = this;

  function comparator(initialValue, item) {
    return angular.equals(initialValue, ctrl.getValue(item));
  }

  function createGetter(accessor) {
    return accessor && $parse(accessor);
  }

  this.getLabel = createGetter($scope.properties.displayedKey) || function (item) {
    return typeof item === 'string' ? item : JSON.stringify(item);
  };

  this.getValue = createGetter($scope.properties.returnedKey) || function (item) {
    return item;
  };

  this.findSelectedItem = function (items) {
    return items.filter(comparator.bind(null, $scope.properties.value))
      .map(function (item) {
        return ctrl.getValue(item);
      })[0];
  };

  this.setSelectedValue = function (foundItem) {
    $timeout(function () {
      if (foundItem) {
        $scope.properties.value = foundItem;
      } else {
        $scope.properties.value = null;
      }
    }, 0);
  };

  $scope.$watchCollection('properties.availableValues', function(items) {
    if (Array.isArray(items)) {
      var foundItem = ctrl.findSelectedItem(items);

      //force IE9 to rerender option list
      if ($window.navigator && $window.navigator.userAgent && $window.navigator.userAgent.indexOf('MSIE 9') >= 0) {
        var option = document.createElement('option');
        var select = $element.find('select')[0];
        select.add(option,null);
        select.remove(select.options.length-1);
      }

      // terrible hack to force the select ui to show the correct options
      // so we change it's value to undefined and then delay to the correct value
      $scope.properties.value = undefined;
      ctrl.setSelectedValue(foundItem);
    }
  });

  $scope.$watch('properties.value', function(value) {
    if (value) {
      var items = $scope.properties.availableValues;
      if (Array.isArray(items)) {
        var foundItem = ctrl.findSelectedItem(items);

        ctrl.setSelectedValue(foundItem);
      }
    }
  });

  this.name = widgetNameFactory.getName('pbSelect');

  if (!$scope.properties.isBound('value')) {
    $log.error('the pbSelect property named "value" need to be bound to a variable');
  }
}
,
      template: '<div ng-class="{\n    \'form-horizontal\': properties.labelPosition === \'left\' && !properties.labelHidden,\n    \'row\': properties.labelPosition === \'top\' && !properties.labelHidden || properties.labelHidden\n    }">\n    <div class="form-group">\n        <label\n            ng-if="!properties.labelHidden"\n            ng-class="{ \'control-label--required\': properties.required }"\n            class="control-label col-xs-{{ !properties.labelHidden && properties.labelPosition === \'left\' ? properties.labelWidth : 12 }}">\n            {{ properties.label | uiTranslate }}\n        </label>\n        <div class="col-xs-{{ 12 - (!properties.labelHidden && properties.labelPosition === \'left\' ? properties.labelWidth : 0) }}" >\n            <select\n                class="form-control"\n                name="{{ctrl.name}}"\n                ng-model="properties.value"\n                ng-model-options="{ allowInvalid: true }"\n                ng-options="ctrl.getValue(option) as (ctrl.getLabel(option) | uiTranslate) for option in properties.availableValues"\n                ng-required="properties.required"\n                ng-disabled="properties.disabled">\n                <option style="display:none" value="">\n                    {{ properties.placeholder | uiTranslate }}\n                </option>\n            </select>\n            <div ng-messages="$form[ctrl.name].$dirty && $form[ctrl.name].$error " ng-messages-include="forms-generic-errors.html" role="alert"></div>\n        </div>\n    </div>\n</div>\n'
    };
  });
